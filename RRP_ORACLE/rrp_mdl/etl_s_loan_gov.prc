CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_GOV(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_GOV
  *  功能描述：地方政府融资平台贷款整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_LGLC_INFO
  *            M_CPTL_INVEST_INFO
  *            M_CUST_CORP_INFO
  *            M_CPTL_REPO_AST_INFO
  *            M_LOAN_BILL_INFO
  *            M_LOAN_IN_DUBILL_INFO
  *
  *
  *
  *  目标表：  S_LOAN_GOV
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_GOV'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_GOV'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_GOV T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_GOV'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_LOAN_GOV', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑1-贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
       --LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.RCPT_ID AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.LOAN_BAL AS BAL, --余额
             A.LVL5_CL AS LVL5_CL, --五级分类
             A.LOAN_ACT_DSTR_DT AS START_DT, --起始日期
             A.LOAN_ORIG_EXP_DT AS EXP_DT, --到期日期
             A.PRO_IMPT AS PRO_IMPT, --减值准备
             '1' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             A.LOAN_DIR_RGN AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             A.LCL_GOVFINPLTF_LOAN_DIR_RGN AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
             --A.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_LOAN_IN_DUBILL_INFO A --表内借据信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.LCL_GOVFINPLTF_LOAN_FLG = 'Y'
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GOV字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑2-从非金融机构买入返售';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
       LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.ACC_ID AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.BAL AS BAL, --余额
             A.LVL5_CL AS LVL5_CL, --五级分类
             A.START_DT AS START_DT, --起始日期
             A.EXP_DT AS EXP_DT, --到期日期
             A.PRO_IMPT AS PRO_IMPT, --减值准备
             '1' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             A.LCL_GOVFINPLTF_LOAN_DIR AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             B.OPR_LAND_AREA_CD AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
             B.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_CPTL_REPO_AST_INFO A --回购业务（资产方）信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE B.LCL_FIN_PLTF_HIER_TYP IS NOT NULL
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GOV字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑3-投资债券类';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
       LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.ACC_ID AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.BOOK_BAL AS BAL, --余额
             A.LVL5_CL AS LVL5_CL, --五级分类
             A.BIZ_DT AS START_DT, --起始日期
             A.EXP_DT AS EXP_DT, --到期日期
             0 AS PRO_IMPT, --减值准备
             '2' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             '' AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             B.OPR_LAND_AREA_CD AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
             B.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_CPTL_INVEST_INFO A --投资业务信息表
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.OPR_TYP = 'A' --自营
         AND A.INVEST_BIZ_VRTY = 'A01' --债券投资
         AND B.LCL_FIN_PLTF_HIER_TYP IS NOT NULL
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GOV字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑4-表外融资类-银行承兑汇票';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
       LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.DRAWER_ID AS CUST_ID, --客户编号
             A.BILL_NO AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.BILL_PAR_AMT AS BAL, --余额
             '' AS LVL5_CL, --五级分类
             '' AS START_DT, --起始日期
             '' AS EXP_DT, --到期日期
             0 AS PRO_IMPT, --减值准备
             '3' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             '' AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             B.OPR_LAND_AREA_CD AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
             B.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_LOAN_BILL_INFO A --票据出票表
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.DRAWER_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE B.LCL_FIN_PLTF_HIER_TYP IS NOT NULL
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GOV字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 7;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑5-表外融资类-保函与信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
       LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.APP_PSN_ID AS CUST_ID, --客户编号
             A.BIZ_ID AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.TD_PAY_AMT AS BAL, --余额
             '' AS LVL5_CL, --五级分类
             '' AS START_DT, --起始日期
             '' AS EXP_DT, --到期日期
             0 AS PRO_IMPT, --减值准备
             '3' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             '' AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             B.OPR_LAND_AREA_CD AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
             B.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_LOAN_LGLC_INFO A --保函与信用证信息表
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.APP_PSN_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE B.LCL_FIN_PLTF_HIER_TYP IS NOT NULL
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GOV字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '地方政府融资平台贷款整合表--逻辑1-贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_GOV
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       BAL, --余额
       LVL5_CL, --五级分类
       START_DT, --起始日期
       EXP_DT, --到期日期
       PRO_IMPT, --减值准备
       LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
       LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
       LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
       LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
      -- LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.RCPT_ID AS RCPT_ID, --借据编号
             A.CUR AS CUR, --币种
             A.LOAN_BAL AS BAL, --余额
             A.LVL5_CL AS LVL5_CL, --五级分类
             A.LOAN_ACT_DSTR_DT AS START_DT, --起始日期
             A.LOAN_ORIG_EXP_DT AS EXP_DT, --到期日期
             A.PRO_IMPT AS PRO_IMPT, --减值准备
             '1' AS LCL_GOVFINPLTF_FIN_TYP, --地方政府融资平台融资类型
             A.LCL_GOVFINPLTF_FIN_CHAR AS LCL_GOVFINPLTF_FIN_CHAR, --地方政府融资平台融资性质
             A.LOAN_DIR_RGN AS LCL_GOVFINPLTF_LOAN_DIR, --地方政府融资平台贷款投向
             A.LCL_GOVFINPLTF_LOAN_DIR_RGN AS LCL_GOVFINPLTF_LOAN_DIR_RGN, --地方政府融资平台贷款投向地区
            -- A.LCL_FIN_PLTF_HIER_TYP AS LCL_FIN_PLTF_HIER_TYP, --地方融资平台层级类型
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
        FROM M_LOAN_IN_DUBILL_INFO A --表内借据信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.LCL_GOVFINPLTF_LOAN_FLG = 'Y'
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_ENTRS字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_GOV;
/

