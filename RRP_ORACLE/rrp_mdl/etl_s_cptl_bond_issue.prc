CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_BOND_ISSUE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_BOND_ISSUE
  *  功能描述：债券发行整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_BOND_ISSUE_INFO
  *            M_FIN_INST_BOND_INFO
  *  目标表：  S_CPTL_BOND_ISSUE
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221118  于敬艺   新增债券类型代码、债券发行机构、债券发行方式、字段，用于判断专项债券和普通债权
  *             2    20230110  于敬艺   新增剩余账面余额字段
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_BOND_ISSUE'; -- 程序名称
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
  V_TAB_NAME := 'S_CPTL_BOND_ISSUE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_BOND_ISSUE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_BOND_ISSUE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '债券发行整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_BOND_ISSUE
      ( DATA_DT         --数据日期
       ,LGL_REP_ID      --法人编号
       ,CUST_ID         --客户编号
       ,ORG_ID          --机构编号
       ,ACC_ID          --账户编号
       ,SEQ_NO          --流水号
       ,ULYG_PROD_ID    --标的产品编号
       ,CUR             --币种
       ,BOOK_BAL        --账面余额
       ,VAL_DT          --起息日期
       ,ISU_DT          --发行日期
       ,EXP_DT          --到期日期
       ,ACC_TYP         --账户类型
       ,GL_CL           --会计分类
       ,PROD_CL         --产品分类
       ,FIN_DEBT_SUB_CL --金融债细类
       ,PERP_DEBT_FLG   --永续债标志
       ,BIO_FLG         --境内外标志
       ,DEPT_LINE       --部门条线
       ,DATA_SRC        --数据来源
       ,INVEST_TYP      --债券类型代码
       ,ISSU_ORG        --债券发行机构
       ,BOND_ISU_MODE   --债券发行方式
       ,ISU_LAND_CTRY_CD --发行地国家代码
       ,BOND_SUR_AMT    --债券剩余金额     ADD BY 于敬艺 in 20230110
       )
      SELECT  A.DATA_DT         AS DATA_DT         --数据日期
             ,A.LGL_REP_ID      AS LGL_REP_ID      --法人编号
             ,A.CUST_ID         AS CUST_ID         --客户编号
             ,A.ORG_ID          AS ORG_ID          --机构编号
             ,A.ACC_ID          AS ACC_ID          --账户编号
             ,A.SEQ_NO          AS SEQ_NO          --流水号
             ,A.ULYG_PROD_ID    AS ULYG_PROD_ID    --标的产品编号
             ,A.CUR             AS CUR             --币种
             ,A.BOOK_BAL        AS BOOK_BAL        --账面余额
             ,A.VAL_DT          AS VAL_DT          --起息日期
             ,A.ISU_DT          AS ISU_DT          --发行日期
             ,A.EXP_DT          AS EXP_DT          --到期日期
             ,A.ACC_TYP         AS ACC_TYP         --账户类型
             ,A.GL_CL           AS GL_CL           --会计分类
             ,B.PROD_CL         AS PROD_CL         --产品分类
             ,B.FIN_DEBT_SUB_CL AS FIN_DEBT_SUB_CL --金融债细类
             ,A.PERP_DEBT_FLG   AS PERP_DEBT_FLG   --永续债标志
             ,A.BIO_FLG         AS BIO_FLG         --境内外标志
             ,A.DEPT_LINE       AS DEPT_LINE       --部门条线
             ,A.DATA_SRC        AS DATA_SRC         --数据来源
             ,CASE WHEN (B.BOND_TYPE_CD IN ('F') )  THEN 'F05'    --债券类型代码
                   WHEN B.BOND_TYPE_CD IN ('1','M') THEN 'A'
                   WHEN B.BOND_TYPE_CD IN ('5')     THEN 'B'
                   WHEN (B.BOND_TYPE_CD = '9' AND B.PROD_NM LIKE '%小微%')  THEN 'C0601'
                   WHEN (B.BOND_TYPE_CD = '9' AND B.PROD_NM LIKE '%三农%')  THEN 'C0602'
                   WHEN (B.BOND_TYPE_CD = '9' AND B.PROD_NM LIKE '%绿色金融%')  THEN 'C0603'
                   WHEN (B.BOND_TYPE_CD IN ('8','61','C1','C2','C3','C4','C5','C6','C')
                        OR (B.BOND_TYPE_CD = '9'
                            AND B.PROD_NM NOT LIKE '%小微%'
                            AND B.PROD_NM NOT LIKE '%三农%'
                            AND B.PROD_NM NOT LIKE '%绿色金融%'))  THEN 'C05'
                   WHEN B.BOND_TYPE_CD IN ('7','X')  THEN 'C0101'
                   WHEN B.BOND_TYPE_CD = 'L'         THEN 'C03'
                   WHEN B.BOND_TYPE_CD IN ('U')      THEN 'C02'
                   WHEN B.BOND_TYPE_CD IN ('V')      THEN 'C04'
                   WHEN B.BOND_TYPE_CD IN ('Q')      THEN 'C0604'
                   WHEN B.PROD_NM LIKE '%永续债%'    THEN 'C060401' --C060401  永续债
                   WHEN B.BOND_TYPE_CD IN ('6','O')  THEN 'D01'
                   WHEN B.BOND_TYPE_CD IN ('N')      THEN 'D02'
                   WHEN B.BOND_TYPE_CD IN ('I')      THEN 'D03'
                   WHEN B.BOND_TYPE_CD IN ('4','D','J','L1','P') THEN 'D04'
                   WHEN B.BOND_TYPE_CD IN ('E')      THEN 'D05'
                   WHEN B.BOND_TYPE_CD IN ('G','H','K')  THEN 'D99'
                   WHEN B.BOND_TYPE_CD IN ('FG','FL')    THEN 'F01'
                   WHEN B.BOND_TYPE_CD IN ('09')      THEN 'G'
             END       AS INVEST_TYP                                       --   债券类型代码
          ,CASE WHEN B.BOND_TYPE_CD ='M' THEN 'A02'
                WHEN (B.BOND_TYPE_CD ='Q' OR B.ISSUER_NAME = '中央汇金投资有限责任公司') THEN 'B01'
                WHEN NVL(B.BOND_TYPE_CD,'*') NOT IN( 'M','Q')
                THEN( CASE WHEN B.BOND_MAIN_TYPE LIKE '%保险公司%' THEN 'D06'
                          WHEN B.BOND_MAIN_TYPE IN ('财务公司','担保公司','金融控股集团','金融租赁公司'
                                                    ,'期货公司','其他金融机构','信托公司','信用社','投资咨询公司')  THEN 'D07'
                          WHEN B.BOND_MAIN_TYPE IN ('国有资产管理机构','金融资产管理公司') THEN 'D04'
                          WHEN B.BOND_MAIN_TYPE IN ('国资委直属企业','其他公司','企业集团','停业公司','香港主板上市公司')THEN 'C04'
                          WHEN B.BOND_MAIN_TYPE = '机关事业单位' THEN 'B01'
                          WHEN B.BOND_MAIN_TYPE = '商业银行'     THEN 'D03'
                          WHEN B.BOND_MAIN_TYPE = '政策性银行'   THEN 'D02'
                          WHEN B.BOND_MAIN_TYPE = '证券公司'     THEN 'D05'
                          WHEN B.BOND_MAIN_TYPE = '中央部委'     THEN 'A01'
                          WHEN B.BOND_MAIN_TYPE = 'QFII机构'     THEN 'E05'
                     END
              )END      AS       ISSU_ORG                                     --发行机构
            ,B.BOND_ISU_MODE                                                  --债券发行方式
            ,B.ISU_LAND_CTRY_CD                                               --发行地国家代码
            ,A.BOND_SUR_AMT                                                   --债券剩余金额   ADD BY 于敬艺 in 20230110
        FROM RRP_MDL.M_CPTL_BOND_ISSUE_INFO A    --债券发行信息
        LEFT JOIN RRP_MDL.M_FIN_INST_BOND_INFO B --债券基础信息
          ON A.ULYG_PROD_ID = B.BOND_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
          ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

     -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_CPTL_BOND_ISSUE;
/

