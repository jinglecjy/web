package chat;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;

/**
 * @ServerEndpoint 注解是一个类层次的注解，它的功能主要是将目前的类
 * 定义成一个websocket服务器端，注解的值将被用于监听用户连接的终端
 * 访问URL地址,客户端可以通过这个URL来连接到WebSocket服务器端。
 */
@ServerEndpoint(value="/chat")
public class ChatExample {
	private static final Log log = LogFactory.getLog(ChatExample.class);
	private static final String GUEST_PREFIX = "Guest";
	/* AtomicInteger: 线程安全的加减操作接口 */
	private static final AtomicInteger connectionIds = new AtomicInteger(0);
	/* 线程安全的操作集合，开销比较大 */
	private static final Set<ChatExample> connections = 
			new CopyOnWriteArraySet<>();
	private final String nickname;
	private Session session;
	
	public ChatExample(){
		nickname = GUEST_PREFIX + connectionIds.getAndIncrement();
	}
	
	@OnOpen
	public void start(Session session) {
		this.session = session;
		connections.add(this);
		String message = String.format("* %s %s", nickname, "has joined.");
		broadcast(message);
	}
	
	@OnClose
	public void end() {
		connections.remove(this);
		String message = String.format("* %s %s", 
				nickname, "has disconnected.");
		broadcast(message);
	}
	
	@OnMessage
	public void incoming(String message) {
		// 对客户端输入进行过滤，出于网络安全考虑
		String filteredMessage = String.format("%s: %s", 
				nickname, filter(message.toString()));
		broadcast(filteredMessage);
	}
	
	@OnError
	public void onError(Throwable t) throws Throwable {
		log.error("Chat Error: " + t.toString(), t);
	}
	
	public static String filter(String message) {

        if (message == null)
            return (null);

        char content[] = new char[message.length()];
        message.getChars(0, message.length(), content, 0);
        StringBuilder result = new StringBuilder(content.length + 50);
        for (int i = 0; i < content.length; i++) {
            switch (content[i]) {
            case '<':
                result.append("&lt;");
                break;
            case '>':
                result.append("&gt;");
                break;
            case '&':
                result.append("&amp;");
                break;
            case '"':
                result.append("&quot;");
                break;
            default:
                result.append(content[i]);
            }
        }
        return (result.toString());
    }
	
	private static void broadcast(String msg) {
		for(ChatExample client : connections) {
			try {
				synchronized (client) { // 对象同步
					client.session.getBasicRemote().sendText(msg);
				}
			} catch (IOException e) {
				log.debug("Chat Error: Failed to send message to client", e);
				connections.remove(client);
				try {
					client.session.close();
				} catch (IOException e1) {
					// Ignore
				}
				String message = String.format("* %s %s", 
						client.nickname, "has been disconnected.");
				broadcast(message);
			}
		}
	}
}
