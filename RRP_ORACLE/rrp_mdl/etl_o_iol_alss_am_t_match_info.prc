CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ALSS_AM_T_MATCH_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：对公年检信息表
  **存储过程名称：    ETL_O_IOL_ALSS_AM_T_MATCH_INFO
  **存储过程创建日期：20250919
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250919    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ALSS_AM_T_MATCH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ALSS_AM_T_MATCH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公年检信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ALSS_AM_T_MATCH_INFO NOLOGGING 
  (          CUST_NO                 --客户号
            ,OWN_ORGAN               --开户上级机构
            ,ORGAN_CODE              --开户机构
            ,ACCT_NUM                --账号
            ,ACCT_NAME               --账户名称
            ,ACCT_TYPE               --账户性质
            ,LICENCE_REGIST_NUM      --营业执照(注册号)编号
            ,LICENCE_SOCIAL_NUM      --营业执照（统一社会信用代码）编号
            ,OTHER_CREDTYPE          --是否为其他证件种类
            ,CORE_PEOPLE             --核心与人行账户管理系统比对
            ,CORE_BUSINESS           --核心与商事信息
            ,PEOPLE_BUSINESS         --人行账户管理系统与商事信息
            ,SUSPEND_INFO            --久悬账户情况
            ,MANAGE_STATE            --经营状态
            ,ABNORMAL_CON            --是否被列入企业异常名录
            ,ILLEGAL_BREACH          --是否为严重违法失信企业
            ,LAST_INSPECT            --最后年检年度
            ,CHECK_DT                --核查日期
            ,INSPECT_DT              --年检日期
            ,ETL_DT_ORA              --创建日期
            ,ORG_NUM                 --所属机构
            ,ESTABLISH_DT            --企业开立日期
            ,HANDLE_FLAG             --账户处示标示 1-是(已处置)
            ,CORE_PROOF              --核心与验印系统比对
            ,ETL_DT                  --ETL处理日期
            ,ETL_TIMESTAMP           --ETL处理时间戳
    )
    SELECT
              CUST_NO                 --客户号
            ,OWN_ORGAN               --开户上级机构
            ,ORGAN_CODE              --开户机构
            ,ACCT_NUM                --账号
            ,ACCT_NAME               --账户名称
            ,ACCT_TYPE               --账户性质
            ,LICENCE_REGIST_NUM      --营业执照(注册号)编号
            ,LICENCE_SOCIAL_NUM      --营业执照（统一社会信用代码）编号
            ,OTHER_CREDTYPE          --是否为其他证件种类
            ,CORE_PEOPLE             --核心与人行账户管理系统比对
            ,CORE_BUSINESS           --核心与商事信息
            ,PEOPLE_BUSINESS         --人行账户管理系统与商事信息
            ,SUSPEND_INFO            --久悬账户情况
            ,MANAGE_STATE            --经营状态
            ,ABNORMAL_CON            --是否被列入企业异常名录
            ,ILLEGAL_BREACH          --是否为严重违法失信企业
            ,LAST_INSPECT            --最后年检年度
            ,CHECK_DT                --核查日期
            ,INSPECT_DT              --年检日期
            ,ETL_DT_ORA              --创建日期
            ,ORG_NUM                 --所属机构
            ,ESTABLISH_DT            --企业开立日期
            ,HANDLE_FLAG             --账户处示标示 1-是(已处置)
            ,CORE_PROOF              --核心与验印系统比对
            ,ETL_DT                  --ETL处理日期
            ,ETL_TIMESTAMP           --ETL处理时间戳
  FROM IOL.V_ALSS_AM_T_MATCH_INFO --视图-对公年检信息表
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ALSS_AM_T_MATCH_INFO', '', O_ERRCODE);

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

END ETL_O_IOL_ALSS_AM_T_MATCH_INFO;
/

