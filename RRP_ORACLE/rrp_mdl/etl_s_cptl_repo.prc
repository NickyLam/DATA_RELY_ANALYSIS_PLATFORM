CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_REPO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_REPO
  *  功能描述：回购业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_REPO_AST_INFO
  *            M_CUST_CORP_INFO
  *            M_CPTL_REPO_LBY_INFO
  *
  *
  *
  *
  *  目标表：  S_CPTL_REPO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1   20230209   周一威  增加约定返售或回购利息、当期应计利息字段
  *              2   20230817   HYF     修改买入返售SPV部分金融机构类型，SPV部分金融机构类型默认为E20000,该部分
                                        归属特定目的载体
  *              3   20230707   HYF     新增买入返售票据部分
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_REPO'; -- 程序名称
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
  V_TAB_NAME := 'S_CPTL_REPO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_REPO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_REPO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '回购业务整合表--逆回购-买入返售-资产';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_REPO
      ( DATA_DT                 --数据日期
       ,LGL_REP_ID              --法人编号
       ,ACC_ID                  --账户编号
       ,CUST_ID                 --客户编号
       ,ORG_NO
       ,CORP_CUST_TYP           --对公客户类型
       ,FIN_ORG_TYP             --金融机构类型
       ,FIN_ORG_ID              --金融机构编号
       ,BIO_FLG                 --境内外标志
       ,AMT                     --发生额
       ,BAL                     --余额
       ,INT                     --利息
       ,CUR                     --币种
       ,REPO_BIZ_TYP            --回购业务类型
       ,ULYG_AST_TYP            --标的资产类型
       ,ULYG_PROD_ID            --标的产品编号
       ,DEPT_LINE               --部门条线
       ,DATA_SRC                --数据来源
       ,MIC_COP_FLG             --小额贷款公司标志
       ,SUBJ_ID                 --科目
       ,APPT_RESL_OR_REPO_INT   --约定返售或回购利息
       ,CURRT_ACRU_INT          --当期应计利息
       ,INT_AMT                 --利息金额
       )
      SELECT  A.DATA_DT              AS DATA_DT        --数据日期
             ,A.LGL_REP_ID           AS LGL_REP_ID     --法人编号
             ,A.ACC_ID               AS ACC_ID         --账户编号
             ,A.CUST_ID              AS CUST_ID        --客户编号
             ,A.ORG_ID
             ,B.CUST_CL              AS CORP_CUST_TYP  --对公客户类型
             ,CASE WHEN A.SPV_NAME IS NOT NULL 
                   THEN 'E20000'
                   ELSE B.FIN_ORG_TYP 
               END                   AS FIN_ORG_TYP    --金融机构类型
             ,B.FIN_ORG_ID           AS FIN_ORG_ID     --金融机构编号
             ,B.BIO_FLG              AS BIO_FLG        --境内外标志
             ,A.AMT                  AS AMT            --发生额
             ,A.BAL                  AS BAL            --余额
             ,A.INT                  AS INT            --利息
             ,A.CUR                  AS CUR            --币种
             ,A.REPO_BIZ_TYP         AS REPO_BIZ_TYP   --回购业务类型
             ,A.ULYG_AST_TYP         AS ULYG_AST_TYP   --标的资产类型
             ,A.ULYG_PROD_ID         AS ULYG_PROD_ID   --标的产品编号
             ,A.DEPT_LINE            AS DEPT_LINE      --部门条线
             ,A.DATA_SRC             AS DATA_SRC       --数据来源
             ,CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%'
                   THEN 'Y'
                   ELSE 'N'
               END                   AS MIC_COP_FLG    --小额贷款公司标志
             ,A.SUBJ_ID                                --科目
             ,A.APPT_RESL_OR_REPO_INT                  --约定返售或回购利息
             ,NULL                   AS CURRT_ACRU_INT --当期应计利息
             ,NULL                   AS INT_AMT        -- 利息金额
        FROM RRP_MDL.M_CPTL_REPO_AST_INFO A --回购业务（资产方）信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.BAL > 0
         AND A.OPR_TYP = 'A' --自营
         --AND A.DATA_SRC <> '票据回购'
         AND A.REPO_BIZ_TYP LIKE '101%' --买入返售
         AND A.DATA_DT = V_P_DATE;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_CPTL_REPO字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '回购业务整合表--正回购-卖出回购-负债';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_REPO
      ( DATA_DT                     --数据日期
       ,LGL_REP_ID                  --法人编号
       ,ACC_ID                      --账户编号
       ,CUST_ID                     --客户编号
       ,CORP_CUST_TYP               --对公客户类型
       ,ORG_NO
       ,FIN_ORG_TYP                 --金融机构类型
       ,FIN_ORG_ID                  --金融机构编号
       ,BIO_FLG                     --境内外标志
       ,AMT                         --发生额
       ,BAL                         --余额
       ,INT
       ,CUR                         --币种
       ,REPO_BIZ_TYP                --回购业务类型
       ,ULYG_AST_TYP                --标的资产类型
       ,ULYG_PROD_ID                --标的产品编号
       ,DEPT_LINE                   --部门条线
       ,DATA_SRC                    --数据来源
       ,MIC_COP_FLG                 --小额贷款公司标志
       ,SUBJ_ID                     --科目
       ,APPT_RESL_OR_REPO_INT       --约定返售或回购利息
       ,CURRT_ACRU_INT              --当期应计利息
       ,INT_AMT                     --利息金额
       )
      SELECT  A.DATA_DT      AS DATA_DT          --数据日期
             ,A.LGL_REP_ID   AS LGL_REP_ID       --法人编号
             ,A.ACC_ID       AS ACC_ID           --账户编号
             ,A.CUST_ID      AS CUST_ID          --客户编号
             ,B.CUST_CL      AS CORP_CUST_TYP    --对公客户类型
             ,A.ORG_ID
             ,CASE WHEN A.SPV_NAME IS NOT NULL 
                   THEN 'Z20000'
                   ELSE B.FIN_ORG_TYP 
               END           AS FIN_ORG_TYP      --金融机构类型
             ,B.FIN_ORG_ID   AS FIN_ORG_ID       --金融机构编号
             ,B.BIO_FLG      AS BIO_FLG          --境内外标志
             ,A.AMT          AS AMT              --发生额
             ,A.BAL          AS BAL              --余额
             ,A.INT          AS INT              --利息
             ,A.CUR          AS CUR              --币种
             ,A.REPO_BIZ_TYP AS REPO_BIZ_TYP     --回购业务类型
             ,A.ULYG_AST_TYP AS ULYG_AST_TYP     --标的资产类型
             ,A.ULYG_PROD_ID AS ULYG_PROD_ID     --标的产品编号
             ,A.DEPT_LINE    AS DEPT_LINE        --部门条线
             ,A.DATA_SRC     AS DATA_SRC         --数据来源
             ,CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%'
                   THEN 'Y'
                   ELSE 'N'
               END           AS MIC_COP_FLG      --小额贷款公司标志
             ,A.SUBJ_ID                          --科目
             ,A.APPT_RESL_OR_REPO_INT            --约定返售或回购利息
             ,A.CURRT_ACRU_INT                   --当期应计利息
             ,A.INT_AMT                          --利息金额
        FROM RRP_MDL.M_CPTL_REPO_LBY_INFO A --回购业务（负债方）信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.BAL > 0
         AND A.OPR_TYP = 'A' --自营
         AND A.REPO_BIZ_TYP LIKE '201%' --卖出回购
         AND A.DATA_DT = V_P_DATE;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_CPTL_REPO字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_S_CPTL_REPO;
/

