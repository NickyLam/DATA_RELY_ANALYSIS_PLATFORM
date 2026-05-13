CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_SVBS_HX_TRAN_INFO_RECORD(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_SVBS_HX_TRAN_INFO_RECORD
  *  功能描述：交易状态记录表
  *  创建日期：20240805
  *  开发人员：YJY
  *  来源表： IOL.V_SVBS_HX_TRAN_INFO_RECORD
  *  目标表： O_IOL_SVBS_HX_TRAN_INFO_RECORD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240805  YJY      首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_SVBS_HX_TRAN_INFO_RECORD'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_SVBS_HX_TRAN_INFO_RECORD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-交易状态记录表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_SVBS_HX_TRAN_INFO_RECORD
  (
           SESSIONID                --会话ID                                                                                                                                                                                                     
          ,BILLID                   --订单号                                                                                                                                                                                                    
          ,GLOB_SEQ_NUM             --全局流水号                                                                                                                                                                                                
          ,STATUS                   --1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
          ,TRAN_CODE                --交易码                                                                                                                                                                                                    
          ,CHANNEL_TYPE             --发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）                                                                        
          ,SYSTEM_SIGN              --系统标识                                                                                                                                                                                                  
          ,QRCODE                   --小程序二维码base64                                                                                                                                                                                        
          ,CREATE_DATE              --创建日期                                                                                                                                                                                                  
          ,UPDATE_DATE              --最后更新日期                                                                                                                                                                                              
          ,DELETE_FLAG              --删除标识 0- 使用中 1-已删除                                                                                                                                                                               
          ,NOTES                    --备注                                                                                                                                                                                                      
          ,IS_TTS                   --是否开启语音播报， 0-关闭  1-开启                                                                                                                                                                         
          ,IS_ASR                   --是否开启语音识别， 0-关闭  1-开启                                                                                                                                                                         
          ,VIDEO_DURATION           --视频时长，单位毫秒                                                                                                                                                                                        
          ,VIDEO_DURATION_STR       --视频时长字符串，格式00:00:00.00                                                                                                                                                                           
          ,START_DT                 --开始时间                                                                                                                                                                                                  
          ,END_DT                   --结束时间                                                                                                                                                                                                  
          ,ID_MARK                  --增删标志                                                                                                                                                                                                  
          ,ETL_TIMESTAMP            --ETL处理时间戳                                                                                                                                                                                             
           
    )
    SELECT
           SESSIONID                --会话ID                                                                                                                                                                                                     
          ,BILLID                   --订单号                                                                                                                                                                                                    
          ,GLOB_SEQ_NUM             --全局流水号                                                                                                                                                                                                
          ,STATUS                   --1-生成二维码，2-正在双录，4-完成双录，5-影像下载失败 6- 影像下载成功 7-影像上传失败 8-影像上传成功 9-通知关联系统失败 10-通知关联系统成功 11-双录完成通知外系统失败 12-双录完成通知外系统成功  13-异常中断
          ,TRAN_CODE                --交易码                                                                                                                                                                                                    
          ,CHANNEL_TYPE             --发起渠道 1-移动作业平台(PAD)，2-兴金融小程序，3-手机银行（安卓），4-手机银行（IOS），5-企业手机银行（安卓），6-企业手机银行（IOS）                                                                        
          ,SYSTEM_SIGN              --系统标识                                                                                                                                                                                                  
          ,QRCODE                   --小程序二维码base64                                                                                                                                                                                        
          ,CREATE_DATE              --创建日期                                                                                                                                                                                                  
          ,UPDATE_DATE              --最后更新日期                                                                                                                                                                                              
          ,DELETE_FLAG              --删除标识 0- 使用中 1-已删除                                                                                                                                                                               
          ,NOTES                    --备注                                                                                                                                                                                                      
          ,IS_TTS                   --是否开启语音播报， 0-关闭  1-开启                                                                                                                                                                         
          ,IS_ASR                   --是否开启语音识别， 0-关闭  1-开启                                                                                                                                                                         
          ,VIDEO_DURATION           --视频时长，单位毫秒                                                                                                                                                                                        
          ,VIDEO_DURATION_STR       --视频时长字符串，格式00:00:00.00                                                                                                                                                                           
          ,START_DT                 --开始时间                                                                                                                                                                                                  
          ,END_DT                   --结束时间                                                                                                                                                                                                  
          ,ID_MARK                  --增删标志                                                                                                                                                                                                  
          ,ETL_TIMESTAMP            --ETL处理时间戳   
    FROM IOL.V_SVBS_HX_TRAN_INFO_RECORD    --视图-交易状态记录表
   WHERE ID_MARK <> 'D'; 

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_SVBS_HX_TRAN_INFO_RECORD;
/

