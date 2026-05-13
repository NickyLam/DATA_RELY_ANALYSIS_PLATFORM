CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_CD(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_CD
  *  功能描述：存单业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_CD_ISSUE_INFO
  *            M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *            M_CPTL_CD_INVEST_INFO
  *
  *  目标表：  S_CPTL_CD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *                  20221117  于敬艺   修改境内外标识从存单发行信息里取
  *                  20230129  黄一凡   新增居民标志
  *                  20240326  黄一凡   新增银行账簿
  *                  20240412  HYF      新增单位存款类型
  *                  20240501  HYF      新增发行金额
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_CD'; -- 程序名称
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
  V_TAB_NAME := 'S_CPTL_CD'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_CD T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_CD'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '存单业务整合表--逻辑1-存单发行信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_CD
      ( DATA_DT              --数据日期
       ,LGL_REP_ID           --法人编号
       ,ORG_ID               --机构编号
       ,ACC_ID               --账户编号
       ,CUST_ID              --客户编号
       ,CD_NO                --存单号
       ,CUR                  --币种
       ,BOOK_BAL             --账面余额
       ,PBL_INT              --应付利息
       ,CUST_LRG_CL          --客户大类
       ,CORP_CUST_TYP        --对公客户类型
       ,FIN_ORG_TYP          --金融机构类型
       ,FIN_ORG_ID           --金融机构编号
       ,PROD_CL              --产品分类
       ,GL_CL                --会计分类
       ,AST_LBY_FLG          --资产负债标志
       ,BIO_FLG              --境内外标志
       ,EXP_DT               --到期日期
       ,ISU_DT               --发行日期
       ,DEPT_LINE            --部门条线
       ,DATA_SRC             --数据来源
       ,SUBJ_ID              --科目号
       ,RSDNT_FLG            --居民标志
       ,CNTPTY_NAME          --交易对手名称
       ,SPV_CUST_ID          --SPV客户号
       ,C_DEPOSIT_TYP        --单位存款类型
       ,ISSUE_AMT            --发行金额
       )
      SELECT A.DATA_DT                             AS DATA_DT         --数据日期
             ,A.LGL_REP_ID                         AS LGL_REP_ID      --法人编号
             ,A.ORG_ID                             AS ORG_ID          --机构编号
             ,A.ACC_ID                             AS ACC_ID          --账户编号
             ,A.SRC_CUST_ID                        AS CUST_ID         --客户编号
             ,A.CD_NO                              AS CD_NO           --存单号
             ,A.CUR                                AS CUR             --币种
             ,A.BOOK_BAL                           AS BOOK_BAL        --账面余额
             ,A.PBL_INT                            AS PBL_INT         --应付利息
             ,CASE WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' 
                   THEN '01' --对私客户(含个体工商户)
                   WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' 
                   THEN '02' --对公客户（剔除个体工商户）
               END                                 AS CUST_LRG_CL     --客户大类
             ,B.CUST_CL                            AS CORP_CUST_TYP   --对公客户类型
             ,B.FIN_ORG_TYP                        AS FIN_ORG_TYP     --金融机构类型
             ,B.FIN_ORG_ID                         AS FIN_ORG_ID      --金融机构编号
             ,A.PROD_CL                            AS PROD_CL         --产品分类
             ,A.GL_CL                              AS GL_CL           --会计分类
             ,'02'                                 AS AST_LBY_FLG     --资产负债标志
             --NVL(B.BIO_FLG, C.BIO_FLG)
             ,A.BIO_FLG                            AS BIO_FLG         --境内外标志   --modify 于敬艺 in20221117
             ,A.EXP_DT                             AS EXP_DT          --到期日期
             ,A.ISU_DT                             AS ISU_DT          --发行日期
             ,A.DEPT_LINE                          AS DEPT_LINE       --部门条线
             ,A.DATA_SRC                           AS DATA_SRC        --数据来源
             ,A.SUBJ_ID                            AS SUBJ_ID         --科目号
             ,NVL(B.RSDNT_FLG, C.RSDNT_FLG)        AS RSDNT_FLG       --居民标志
             ,A.CNTPTY_FNAME                       AS CNTPTY_NAME     --交易对手名称
             ,A.SPV_CUST_ID                        AS SRC_CUST_ID     --SPV客户号
             ,A.C_DEPOSIT_TYPE                     AS C_DEPOSIT_TYP   --单位存款类型
             ,NVL(A.ISSUE_AMT,0)                   AS ISSUE_AMT       --发行金额
        FROM RRP_MDL.M_CPTL_CD_ISSUE_INFO A --存单发行信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.SRC_CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE;
       
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_CPTL_CD字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := 4;
  V_STEP_DESC := '存单业务整合表--逻辑2-存单投资信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_CD
      ( DATA_DT            --数据日期
       ,LGL_REP_ID         --法人编号
       ,ORG_ID             --机构编号
       ,ACC_ID             --账户编号
       ,CUST_ID            --客户编号
       ,CD_NO              --存单号
       ,CUR                --币种
       ,BOOK_BAL           --账面余额
       ,PBL_INT            --应付利息
       ,CUST_LRG_CL        --客户大类
       ,CORP_CUST_TYP      --对公客户类型
       ,FIN_ORG_TYP        --金融机构类型
       ,FIN_ORG_ID         --金融机构编号
       ,PROD_CL            --产品分类
       ,GL_CL              --会计分类
       ,AST_LBY_FLG        --资产负债标志
       ,BIO_FLG            --境内外标志
       ,EXP_DT             --到期日期
       ,ISU_DT             --发行日期
       ,DEPT_LINE          --部门条线
       ,DATA_SRC           --数据来源
       ,SUBJ_ID            --科目号
       ,FIN_AST_CL         --金融资产分类
       ,ACC_TYP            --账户类型
       ,RSDNT_FLG          --居民标志
       ,ACCT_B_CATE_CD     --账簿类型
       )
      SELECT  A.DATA_DT                   AS DATA_DT          --数据日期
             ,A.LGL_REP_ID                AS LGL_REP_ID       --法人编号
             ,A.ORG_ID                    AS ORG_ID
             ,A.ACC_ID                    AS ACC_ID           --账户编号
             ,A.CUST_ID                   AS CUST_ID          --客户编号
             ,A.CD_NO                     AS CD_NO            --存单号
             ,A.CUR                       AS CUR              --币种
             ,A.BOOK_BAL                  AS BOOK_BAL         --账面余额
             ,A.RECV_INT                  AS PBL_INT          --应付利息
             ,'02'                        AS CUST_LRG_CL      --客户大类
             ,B.CUST_CL                   AS CORP_CUST_TYP    --对公客户类型
             ,B.FIN_ORG_TYP               AS FIN_ORG_TYP      --金融机构类型
             ,B.FIN_ORG_ID                AS FIN_ORG_ID       --金融机构编号
             ,A.PROD_CL                   AS PROD_CL          --产品分类
             ,A.GL_CL                     AS GL_CL            --会计分类
             ,'01'                        AS AST_LBY_FLG      --资产负债标志
             ,B.BIO_FLG                   AS BIO_FLG          --境内外标志
             ,A.EXP_DT                    AS EXP_DT           --到期日期
             ,A.ISU_DT                    AS ISU_DT           --发行日期
             ,A.DEPT_LINE                 AS DEPT_LINE        --部门条线
             ,A.DATA_SRC                  AS DATA_SRC         --数据来源
             ,A.SUBJ_ID                   AS SUBJ_ID          --科目号
             ,A.FIN_AST_CL                AS FIN_AST_CL       --金融资产分类
             ,A.ACC_TYP                   AS ACC_TYP          --账户类型
             ,NVL(B.RSDNT_FLG,C.RSDNT_FLG) AS RSDNT_FLG       --居民标志
             ,A.ACCT_B_CATE_CD            AS ACCT_B_CATE_CD   --银行账簿
        FROM M_CPTL_CD_INVEST_INFO A --存单投资信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE;
       
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

  END ETL_S_CPTL_CD;
/

