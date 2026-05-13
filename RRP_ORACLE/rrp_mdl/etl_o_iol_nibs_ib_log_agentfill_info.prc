CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NIBS_IB_LOG_AGENTFILL_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：代理人补录登记簿
  **存储过程名称：    ETL_O_IOL_NIBS_IB_LOG_AGENTFILL_INFO
  **存储过程创建日期：20241220
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20241220    YJY        创建
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NIBS_IB_LOG_AGENTFILL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NIBS_IB_LOG_AGENTFILL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-代理人补录登记簿';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NIBS_IB_LOG_AGENTFILL_INFO NOLOGGING 
  (      CHANNELDATE               --渠道日期
        ,CHAN_BIZ_SEQ_NUM          --渠道流水号
        ,TX_SEQ_NUM                --业务流水号
        ,ORIG_TX_SEQ_NUM           --原交易业务流水号（交易订单号）
        ,ORIG_CORE_TRAN_FLOW_NUM   --原交易全局流水号
        ,BLIP_ID                   --影像批次号
        ,ISAGENT                   --是否代办
        ,AGENT_PERSON_NAME         --代办人名称
        ,AGENT_PERSON_CERT_TYPE_CD --代办人证件类型
        ,AGENT_PERSON_CERT_NUM     --代办人证件号码
        ,AGENT_PERSON_TEL_NUM      --代办人手机号或代办人电话号码
        ,AGENT_PERSON_NATION_CD    --代办人国籍
        ,AGENT_GENDER_CD           --代办人性别
        ,AGENT_CAREER_TYPEONE_CODE --代办人职业-分类1代码
        ,AGENT_CAREER_TYPEONE      --代办人职业-分类1名称
        ,AGENT_CAREER_TYPETWO_CODE --代办人职业-分类2代码
        ,AGENT_CAREER_TYPETWO      --代办人职业-分类2名称
        ,AGENT_CAREER_CD           --代办人职业（详细说明）
        ,AGENT_PERSON_PROVINCECODE --代办人联系地址-省代码
        ,AGENT_PERSON_PROVINCE     --代办人联系地址-省名称
        ,AGENT_PERSON_CITYCODE     --代办人联系地址-市代码
        ,AGENT_PERSON_CITY         --代办人联系地址-市名称
        ,AGENT_PERSON_COUNTYCODE   --代办人联系地址-区代码
        ,AGENT_PERSON_COUNTY       --代办人联系地址-区名称
        ,AGENT_PERSON_CONTACT_ADR  --代办人联系地址（详细地址）
        ,AGENT_PERSON_AUTH_ADR     --代办人发证机关地址
        ,AGENT_PERSON_START_DT     --代办人证件开始日期
        ,AGENT_PERSON_END_DT       --代办人证件到期日期
        ,AGENT_TYPE                --代理人类型（1-普通代理；2-监护代理；3-经办人办理）
        ,AGENT_PERSON_REASON       --代办理由
        ,AGENT_PERSON_NETWORKCHK_SERNO    --代办人联网核查流水号
        ,AGENT_PERSON_NETWORKCHK_RET      --代办人联网核查结果
        ,AGENT_PERSON_FACEIDENT_RES       --代办人人脸识别结果
        ,AGENT_PERSON_FACEIDENT_SCORE     --代办人人脸识别分数
        ,AGENT_PERSON_HANDCHK_RET         --代办人手工审定结果 1-通过 2-强制通过 3-不通过
        ,NOTE1                     --备用1
        ,NOTE2                     --备用2
        ,ORIG_CHANNELDATE          --原交易渠道日期
        ,ETL_DT                    --ETL处理日期
        ,ETL_TIMESTAMP             --ETL处理时间戳
    )
    SELECT
         CHANNELDATE               --渠道日期
        ,CHAN_BIZ_SEQ_NUM          --渠道流水号
        ,TX_SEQ_NUM                --业务流水号
        ,ORIG_TX_SEQ_NUM           --原交易业务流水号（交易订单号）
        ,ORIG_CORE_TRAN_FLOW_NUM   --原交易全局流水号
        ,BLIP_ID                   --影像批次号
        ,ISAGENT                   --是否代办
        ,AGENT_PERSON_NAME         --代办人名称
        ,AGENT_PERSON_CERT_TYPE_CD --代办人证件类型
        ,AGENT_PERSON_CERT_NUM     --代办人证件号码
        ,AGENT_PERSON_TEL_NUM      --代办人手机号或代办人电话号码
        ,AGENT_PERSON_NATION_CD    --代办人国籍
        ,AGENT_GENDER_CD           --代办人性别
        ,AGENT_CAREER_TYPEONE_CODE --代办人职业-分类1代码
        ,AGENT_CAREER_TYPEONE      --代办人职业-分类1名称
        ,AGENT_CAREER_TYPETWO_CODE --代办人职业-分类2代码
        ,AGENT_CAREER_TYPETWO      --代办人职业-分类2名称
        ,AGENT_CAREER_CD           --代办人职业（详细说明）
        ,AGENT_PERSON_PROVINCECODE --代办人联系地址-省代码
        ,AGENT_PERSON_PROVINCE     --代办人联系地址-省名称
        ,AGENT_PERSON_CITYCODE     --代办人联系地址-市代码
        ,AGENT_PERSON_CITY         --代办人联系地址-市名称
        ,AGENT_PERSON_COUNTYCODE   --代办人联系地址-区代码
        ,AGENT_PERSON_COUNTY       --代办人联系地址-区名称
        ,AGENT_PERSON_CONTACT_ADR  --代办人联系地址（详细地址）
        ,AGENT_PERSON_AUTH_ADR     --代办人发证机关地址
        ,AGENT_PERSON_START_DT     --代办人证件开始日期
        ,AGENT_PERSON_END_DT       --代办人证件到期日期
        ,AGENT_TYPE                --代理人类型（1-普通代理；2-监护代理；3-经办人办理）
        ,AGENT_PERSON_REASON       --代办理由
        ,AGENT_PERSON_NETWORKCHK_SERNO    --代办人联网核查流水号
        ,AGENT_PERSON_NETWORKCHK_RET      --代办人联网核查结果
        ,AGENT_PERSON_FACEIDENT_RES       --代办人人脸识别结果
        ,AGENT_PERSON_FACEIDENT_SCORE     --代办人人脸识别分数
        ,AGENT_PERSON_HANDCHK_RET         --代办人手工审定结果 1-通过 2-强制通过 3-不通过
        ,NOTE1                     --备用1
        ,NOTE2                     --备用2
        ,ORIG_CHANNELDATE          --原交易渠道日期
        ,ETL_DT                    --ETL处理日期
        ,ETL_TIMESTAMP             --ETL处理时间戳
    FROM IOL.V_NIBS_IB_LOG_AGENTFILL_INFO;  --视图-代理人补录登记簿
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NIBS_IB_LOG_AGENTFILL_INFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IOL_NIBS_IB_LOG_AGENTFILL_INFO;
/

