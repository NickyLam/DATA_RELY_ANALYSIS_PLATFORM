CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_TELLER_INFO(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                      )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_TELLER_INFO
  *  功能描述：柜员信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_TELLER_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  --定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  --V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_TELLER_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_TELLER_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_TELLER_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_TELLER_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-柜员信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_TELLER_INFO
    (ETL_DT                    --数据日期
    ,LP_ID                     --法人编号
    ,TELLER_ID                 --柜员编号
    ,TELLER_NAME               --柜员名称
    ,TELLER_TYPE_CD            --柜员类型代码
    ,TELLER_STATUS_CD          --柜员状态代码
    ,TELLER_USER_LEV_CD        --柜员用户级别代码
    ,TELLER_PRVLG_LEV_CD       --柜员权限级别代码
    ,BELONG_ORG_ID             --所属机构编号
    ,JOBS_CD                   --岗位代码
    ,JOBS_CATE                 --岗位类别
    ,JOBS_NAME                 --岗位名称
    ,EMPYT_DT                  --入职日期
    ,CUST_MGR_FLG              --客户经理标志
    ,ENTY_TELLER_FLG           --实体柜员标志
    ,SYN_TELLER_FLG            --综合柜员标志
    ,SUPER_TELLER_FLG          --超级柜员标志
    ,ACCT_TELLER_FLG           --账务柜员标志
    ,PRVLG_MGMT_FLG            --权限管理标志
    ,DIRECTOR_MGMT_FLG         --主管管理标志
    ,CRDT_CUST_MGR_FLG         --信贷客户经理标志
    ,WAH_KEPR_FLG              --库管员标志
    ,AUTH_FLG                  --授权标志
    ,AUTH_RANGE                --授权范围
    ,CORS_MOY_BOX_ID           --对应钱箱编号
    ,TELLER_TYPE_SUBCLASS_CD   --柜员明细分类
    ,JOB_CD                    --任务代码
    )
  SELECT 
     ETL_DT                    --数据日期
    ,LP_ID                     --法人编号
    ,TELLER_ID                 --柜员编号
    ,TELLER_NAME               --柜员名称
    ,TELLER_TYPE_CD            --柜员类型代码
    ,TELLER_STATUS_CD          --柜员状态代码
    ,TELLER_USER_LEV_CD        --柜员用户级别代码
    ,TELLER_PRVLG_LEV_CD       --柜员权限级别代码
    ,BELONG_ORG_ID             --所属机构编号
    ,JOBS_CD                   --岗位代码
    ,JOBS_CATE                 --岗位类别
    ,JOBS_NAME                 --岗位名称
    ,EMPYT_DT                  --入职日期
    ,CUST_MGR_FLG              --客户经理标志
    ,ENTY_TELLER_FLG           --实体柜员标志
    ,SYN_TELLER_FLG            --综合柜员标志
    ,SUPER_TELLER_FLG          --超级柜员标志
    ,ACCT_TELLER_FLG           --账务柜员标志
    ,PRVLG_MGMT_FLG            --权限管理标志
    ,DIRECTOR_MGMT_FLG         --主管管理标志
    ,CRDT_CUST_MGR_FLG         --信贷客户经理标志
    ,WAH_KEPR_FLG              --库管员标志
    ,AUTH_FLG                  --授权标志
    ,AUTH_RANGE                --授权范围
    ,CORS_MOY_BOX_ID           --对应钱箱编号
    ,TELLER_TYPE_SUBCLASS_CD   --柜员明细分类
    ,JOB_CD                    --任务代码
    FROM ICL.V_CMM_TELLER_INFO  --视图-柜员信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  --程序跑批结束记录 --
  V_STEP_DESC := '--程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_TELLER_INFO;
/

