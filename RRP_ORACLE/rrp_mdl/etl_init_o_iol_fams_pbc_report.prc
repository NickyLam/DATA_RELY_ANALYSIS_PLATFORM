CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_FAMS_PBC_REPORT (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_FAMS_PBC_REPORT
  *  功能描述：人行报表
  *  创建日期：20221211
  *  开发人员：梅炜
  *  来源表： IOL.V_FAMS_PBC_REPORT
  *  目标表： O_IOL_FAMS_PBC_REPORT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221211  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_FAMS_PBC_REPORT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_FAMS_PBC_REPORT  ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_FAMS_PBC_REPORT ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-人行报表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_FAMS_PBC_REPORT
  (
      REPORTUUID  --主键
      ,TERMID  --期数
      ,REPORTTYPE  --报表类型:
      ,STARTDATE  --开始日期
      ,ENDDATE  --结束日期
      ,ISSUE_PARTY_ID  --发行机构代码
      ,ISSUE_PARTY_NAME  --发行机构名称
      ,REPORTFREQU  --报表频率：D-日，WE-周报，M-月报，S-季，Y-年
      ,REPORT_ORG_NAME  --填报机构名称
      ,SOCIAL_CREDIT_CODE  --社会信用代码
      ,FIN_INSTITUTION_CODE  --金融机构编码
      ,PROD_VARIETY  --产品品种
      ,PERSON_LIABLE  --责任人
      ,CONTACT  --联系方式
      ,REPORT_DATE  --制表日期
      ,SUBMIT_TIME  --报送日期
      ,CHB_SUBMIT_DEADLINE  --中债报送截止日
      ,SUBMIT_DEADLINE  --行内报送截止日
      ,SUBMIT_FEEDBACK_STATUS  --返回信息
      ,STATUS  --有效状态
      ,SEND_STATUS  --报送状态
      ,STATUS_DATE  --数据日期
      ,CREATE_USER  --创建人
      ,CREATE_TIME  --创建时间
      ,UPDATE_USER  --更新人
      ,UPDATE_TIME  --更新时间
      ,ORG_CODE  --机构代码
      ,DEPT_CODE  --部门代码
      ,CREATE_DEPT  --创建部门
      ,PBC_ACCOUNT_ID  --资产池代码
      ,ETL_DT  --ETL处理日期
      ,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT
        REPORTUUID  --主键
        ,TERMID  --期数
        ,REPORTTYPE  --报表类型:
        ,STARTDATE  --开始日期
        ,ENDDATE  --结束日期
        ,ISSUE_PARTY_ID  --发行机构代码
        ,ISSUE_PARTY_NAME  --发行机构名称
        ,REPORTFREQU  --报表频率：D-日，WE-周报，M-月报，S-季，Y-年
        ,REPORT_ORG_NAME  --填报机构名称
        ,SOCIAL_CREDIT_CODE  --社会信用代码
        ,FIN_INSTITUTION_CODE  --金融机构编码
        ,PROD_VARIETY  --产品品种
        ,PERSON_LIABLE  --责任人
        ,CONTACT  --联系方式
        ,REPORT_DATE  --制表日期
        ,SUBMIT_TIME  --报送日期
        ,CHB_SUBMIT_DEADLINE  --中债报送截止日
        ,SUBMIT_DEADLINE  --行内报送截止日
        ,SUBMIT_FEEDBACK_STATUS  --返回信息
        ,STATUS  --有效状态
        ,SEND_STATUS  --报送状态
        ,STATUS_DATE  --数据日期
        ,CREATE_USER  --创建人
        ,CREATE_TIME  --创建时间
        ,UPDATE_USER  --更新人
        ,UPDATE_TIME  --更新时间
        ,ORG_CODE  --机构代码
        ,DEPT_CODE  --部门代码
        ,CREATE_DEPT  --创建部门
        ,PBC_ACCOUNT_ID  --资产池代码
        ,ETL_DT  --ETL处理日期
        ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IOL.V_FAMS_PBC_REPORT
      --视图-人行报表
;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_FAMS_PBC_REPORT ;
/

