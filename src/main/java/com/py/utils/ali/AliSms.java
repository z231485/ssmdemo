package com.py.utils.ali;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;

public class AliSms {
	  
	
	  /*****************短信模板*******************/
	  public static final String TEMPLATE = "";
	  
	  
	  //产品名称:云通信短信API产品,开发者无需替换
	  private static final String product = "Dysmsapi";
	  //产品域名,开发者无需替换
	  private static final String domain = "dysmsapi.aliyuncs.com";
	  
	  //此处需要替换成开发者自己的AK(在阿里云访问控制台寻找)
	  private static final String accessKeyId = "";
	  private static final String accessKeySecret = "";
	  
	  //签名
	  private static final String autograph = "云通信";
	  
	  
	  public static boolean sendMSM(String phone,String templateId,String json) throws ClientException{
		//可自助调整超时时间
		System.setProperty("sun.net.client.defaultConnectTimeout", "10000");
		System.setProperty("sun.net.client.defaultReadTimeout", "10000");
		
		//初始化acsClient,暂不支持region化
		IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", accessKeyId, accessKeySecret);
		DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
		IAcsClient acsClient = new DefaultAcsClient(profile);
		
		//组装请求对象-具体描述见控制台-文档部分内容
		SendSmsRequest request = new SendSmsRequest();
		//必填:待发送手机号
		request.setPhoneNumbers(phone);
		//必填:短信签名-可在短信控制台中找到
		request.setSignName(autograph);
		//必填:短信模板-可在短信控制台中找到
		request.setTemplateCode(templateId);
		//可选:模板中的变量替换JSON串,如模板内容为"您的验证码为${code}"时,此处的值为 {\"code\":\"123\"}
		request.setTemplateParam(json);
		//选填-上行短信扩展码(无特殊需求用户请忽略此字段)
        //request.setSmsUpExtendCode("90997");
        //可选:outId为提供给业务方扩展字段,最终在短信回执消息中将此值带回给调用者
        //request.setOutId("yourOutId");
		//hint 此处可能会抛出异常，注意catch
		SendSmsResponse sendSmsResponse = acsClient.getAcsResponse(request);
		if(sendSmsResponse.getCode() != null && sendSmsResponse.getCode().equals("OK")) {
			return true;
	    }else {
	    	return false;
	    }
	}
	  
	
	  
}
