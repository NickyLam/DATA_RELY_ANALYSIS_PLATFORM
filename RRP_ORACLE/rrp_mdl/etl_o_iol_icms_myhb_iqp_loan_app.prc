CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_MYHB_IQP_LOAN_APP(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_MYHB_IQP_LOAN_APP
  *  功能描述：花呗申请信息
  *  创建日期：20230216
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_ICMS_MYHB_IQP_LOAN_APP
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230216  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_MYHB_IQP_LOAN_APP'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_MYHB_IQP_LOAN_APP';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_MYHB_IQP_LOAN_APP NOLOGGING
    (
						SERIALNO  --业务流水号
						,VALIDITYOFPROD  --协议有效期
						,LASTADVICEDATE  --终审通知时间
						,MIGTFLAG  --MIGT标志
						,APPLYDATE  --申请日期
						,APPROVESTATUS  --审批状态
						,CUSMGR  --客户经理
						,SEXNEW  --新性别
						,CERTTYPE  --证件类型
						,APPLYAMOUNT  --审批额度(元)
						,RISKRATING  --风险评级
						,CUSID  --客户号
						,STARTDATE  --审批开始时间
						,PRDCODE  --产品编号
						,CERTCODENEW  --新证件号码
						,HASHBADMIT  --是否之前就有花呗额度
						,ENDDATE  --审批结束时间
						,INSTCODE  --推荐方机构ID
						,ISCHECKRULE  --准入规则校验结果
						,ZMAUTHFLAG  --芝麻授权成功表示
						,PLATFORMACCESS  --蚂蚁金服审批结果
						,VALIDDATESTARTNEW  --新证件有效期起始日
						,ADDRESSNEW  --新地址
						,MOBILENO  --手机号
						,JOININSTCODES  --参与联合审批机构ID列表
						,NATIONALITYNEW  --新国籍
						,RULINGIR  --日利率
						,AGREEMENTNO  --协议编号
						,CERTCODE  --证件号码
						,SOLVENCYRATINGS  --偿债能力评级
						,INVITESTATUS  --邀约是否通过
						,CLOSETIME  --用户解约的具体时间
						,MNGBRID  --主管机构
						,CERTTYPENEW  --新证件类型
						,APPLYNO  --蚂蚁申请单号
						,PLATFORMMAXAMT  --最大额度(元)
						,PLATFORMREFUSEREASON  --蚂蚁金服拒绝原因
						,RATETYPE  --利率类型1基准利率2LPR
						,PROFESSIONNEW  --新职业
						,FAILREASON  --拒绝原因
						,CHANGERESULTREASON  --额度、定价变更原因
						,REFUSEREASON  --返回蚂蚁花呗的拒绝原因
						,CUSNAMENEW  --新姓名
						,CERTVALIDENDDATE  --证件有效期
						,CONTRACTTEXT  --缔约文本
						,VALIDDATEENDNEW  --新证件有效期到期日
						,TELENEW  --新联系方式
						,APPROVEPROGRESS  --进度说明
						,CUSNAME  --姓名
						,AUTHTEXT  --用户授权协议概要信息
						,CONSUMINGSCORE  --消费能力评分
						,START_DT  --开始时间
						,END_DT  --结束时间
						,ID_MARK  --增删标志
						,ETL_TIMESTAMP  --ETL处理时间戳

     )
  SELECT /*+PARALLEL*/
						SERIALNO  --业务流水号
						,VALIDITYOFPROD  --协议有效期
						,LASTADVICEDATE  --终审通知时间
						,MIGTFLAG  --MIGT标志
						,APPLYDATE  --申请日期
						,APPROVESTATUS  --审批状态
						,CUSMGR  --客户经理
						,SEXNEW  --新性别
						,CERTTYPE  --证件类型
						,APPLYAMOUNT  --审批额度(元)
						,RISKRATING  --风险评级
						,CUSID  --客户号
						,STARTDATE  --审批开始时间
						,PRDCODE  --产品编号
						,CERTCODENEW  --新证件号码
						,HASHBADMIT  --是否之前就有花呗额度
						,ENDDATE  --审批结束时间
						,INSTCODE  --推荐方机构ID
						,ISCHECKRULE  --准入规则校验结果
						,ZMAUTHFLAG  --芝麻授权成功表示
						,PLATFORMACCESS  --蚂蚁金服审批结果
						,VALIDDATESTARTNEW  --新证件有效期起始日
						,ADDRESSNEW  --新地址
						,MOBILENO  --手机号
						,JOININSTCODES  --参与联合审批机构ID列表
						,NATIONALITYNEW  --新国籍
						,RULINGIR  --日利率
						,AGREEMENTNO  --协议编号
						,CERTCODE  --证件号码
						,SOLVENCYRATINGS  --偿债能力评级
						,INVITESTATUS  --邀约是否通过
						,CLOSETIME  --用户解约的具体时间
						,MNGBRID  --主管机构
						,CERTTYPENEW  --新证件类型
						,APPLYNO  --蚂蚁申请单号
						,PLATFORMMAXAMT  --最大额度(元)
						,PLATFORMREFUSEREASON  --蚂蚁金服拒绝原因
						,RATETYPE  --利率类型1基准利率2LPR
						,PROFESSIONNEW  --新职业
						,FAILREASON  --拒绝原因
						,CHANGERESULTREASON  --额度、定价变更原因
						,REFUSEREASON  --返回蚂蚁花呗的拒绝原因
						,CUSNAMENEW  --新姓名
						,CERTVALIDENDDATE  --证件有效期
						,CONTRACTTEXT  --缔约文本
						,VALIDDATEENDNEW  --新证件有效期到期日
						,TELENEW  --新联系方式
						,APPROVEPROGRESS  --进度说明
						,CUSNAME  --姓名
						,AUTHTEXT  --用户授权协议概要信息
						,CONSUMINGSCORE  --消费能力评分
						,START_DT  --开始时间
						,END_DT  --结束时间
						,ID_MARK  --增删标志
						,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ICMS_MYHB_IQP_LOAN_APP   --主指令表(视图)_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_O_IOL_ICMS_MYHB_IQP_LOAN_APP;
/

