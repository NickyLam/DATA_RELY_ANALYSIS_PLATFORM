CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_INVEST_DIR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_INVEST_DIR
  *  功能描述：投资业务投向整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_INVEST_DIR
  *            M_CPTL_INVEST_INFO
  *            M_CUST_CORP_INFO
  *            M_FIN_INST_BOND_INFO
  *            M_FIN_INST_ULYG_INFO
  *
  *  目标表：  S_CPTL_INVEST_DIR
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1   20220110   周一威  增加字段、修改关联条件
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_INVEST_DIR'; -- 程序名称
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
  V_TAB_NAME := 'S_CPTL_INVEST_DIR'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_INVEST_DIR T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_INVEST_DIR'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '投资业务整合表--（债券、股票、基金、其他证券、股权、长期股权）';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CPTL_INVEST_DIR
      ( DATA_DT                          --数据日期
       ,LGL_REP_ID                       --法人编号
       ,ORG_ID                           --机构编号
       ,ACC_ID                           --账户编号
       ,UNDERLYING_BASE_AST_ID           --底层基础资产编号
       ,CUR                              --币种
       ,THRO_AFTER_BAL                   --穿透后余额
       ,THRO_BFR_INVEST_BIZ_TYP          --穿透前投资业务类型
       ,THRO_BFR_PROD_CL                 --穿透前产品分类
       ,FNL_DIR_TYP                      --最终投向类型
       ,FNL_DIR_IDY                      --最终投向行业
       ,AST_SPRT_SCR_SUB_CL              --资产支持证券细类
       ,CRED_RTS_FIN_PROD_SUB_CL         --债权融资类产品细类
       ,MGT_MODE                         --管理方式
       ,ISU_SUBJ_RTG                     --发行主体评级
       ,DEPT_LINE                        --部门条线
       ,DATA_SRC                         --数据来源
       ,BOOK_BAL                         --账面余额
       ,BOOK_BAL_CNY                     --账面余额_折人民币
       ,ULYG_PROD_ID                     --标的产品编号
       ,INVEST_TYP                       --投资大类代码
       ,FNL_DIR_RATIO                    --最终投向比例
       ,RID                              --业务主键
       ,OVDUE_FLG                        --逾期标志
       ,BASIC_ASSET_RATING               --底层资产评级
       )
      SELECT  A.DATA_DT                                         AS DATA_DT                     --数据日期
             ,A.LGL_REP_ID                                      AS LGL_REP_ID                  --法人编号
             ,A.ORG_ID                                          AS ORG_ID                      --机构编号
             ,A.ACC_ID                                          AS ACC_ID                      --账户编号
             ,A.UNDERLYING_BASE_AST_ID                          AS UNDERLYING_BASE_AST_ID      --底层基础资产编号
             ,A.CUR                                             AS CUR                         --币种
             ,A.THRO_AFTER_BAL                                  AS THRO_AFTER_BAL              --穿透后余额
             ,B.INVEST_BIZ_VRTY                                 AS THRO_BFR_INVEST_BIZ_TYP     --穿透前投资业务类型
             ,NVL(D.PROD_CL, E.ULYG_PROD_CL)                    AS THRO_BFR_PROD_CL            --穿透前产品分类
             ,A.FNL_DIR_TYP                                     AS FNL_DIR_TYP                 --最终投向类型
             ,A.FNL_DIR_IDY                                     AS FNL_DIR_IDY                 --最终投向行业
             ,A.AST_SPRT_SCR_SUB_CL                             AS AST_SPRT_SCR_SUB_CL         --资产支持证券细类
             ,A.CRED_RTS_FIN_PROD_SUB_CL                        AS CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
             ,NVL(F.MGT_MOD,B.MGT_MOD)                          AS MGT_MODE                    --管理方式
             ,D.ISU_SUBJ_RTG                                    AS ISU_SUBJ_RTG                --发行主体评级
             ,A.DEPT_LINE                                       AS DEPT_LINE                   --部门条线
             ,A.DATA_SRC                                        AS DATA_SRC                    --数据来源
             ,NVL(F.BOOK_BAL, 0)                                AS BOOK_BAL                    --账面余额
             ,NVL(F.BOOK_BAL, 0) * G.EXRT                       AS BOOK_BAL_CNY                --账面余额_折人民币
             ,A.STD_PROD_ID                                     AS ULYG_PROD_ID                --标的产品编号
             ,CASE WHEN F.INVEST_BIZ_VRTY = 'A01' THEN '00'
                   ELSE CASE WHEN F.ASSET_NAME LIKE '%交易所资产支持证券%' OR (F.ASSET_NAME LIKE '%资管%' AND F.ASSET_NAME NOT LIKE '%票据资管计划%' )
                               OR F.ASSET_NAME LIKE '%交易所公司债%' OR F.ASSET_NAME LIKE '%资产管理产品%'  OR  F.ASSET_NAME LIKE '%资产管理计划%' THEN '12'
                             WHEN F.ASSET_NAME LIKE '%理财%' THEN '05'
                             WHEN F.ASSET_NAME LIKE '%信托%' OR F.ASSET_NAME LIKE '%银登中心%' THEN '04'
                             WHEN F.ASSET_NAME LIKE '%基金%' THEN '01'
                             WHEN F.ASSET_NAME LIKE '%票据资管计划%' THEN '00'
                             ELSE '99'
                         END
               END                                               AS INVEST_TYP                  --投资大类代码
             ,A.FNL_DIR_RATIO                                    AS FNL_DIR_RATIO               --最终投向比例
             ,A.RID                                              AS RID                         --业务主键
             ,A.OVDUE_FLG                                        AS OVDUE_FLG                   --逾期标志
             ,A.BASIC_ASSET_RATING                               AS BASIC_ASSET_RATING           --'底层资产评级'
        FROM RRP_MDL.M_CPTL_INVEST_DIR A --投资业务投向信息表
        LEFT JOIN (SELECT DISTINCT ACC_ID,CUST_ID,ULYG_PROD_ID,MGT_MOD,INVEST_BIZ_VRTY
                     FROM RRP_MDL.M_CPTL_INVEST_INFO --投资业务信息
                    WHERE DATA_DT = V_P_DATE) B --投资业务信息
          ON A.ACC_ID = B.ACC_ID
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
          ON B.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN (SELECT BOND_ID,
                          PROD_CL,
                          ISU_SUBJ_RTG,
                          row_number() over(partition by BOND_ID order by PROD_CL, ISU_SUBJ_RTG) as rn
                     FROM RRP_MDL.M_FIN_INST_BOND_INFO --债券基础信息
                    WHERE DATA_DT = V_P_DATE
                  ) D
          ON D.RN='1'
         AND B.ULYG_PROD_ID = D.BOND_ID
        LEFT JOIN RRP_MDL.M_FIN_INST_ULYG_INFO E --标的物基础信息
          ON B.ULYG_PROD_ID = E.ULYG_ID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CPTL_INVEST_INFO F --投资业务信息
          ON F.DATA_DT= V_P_DATE
         AND A.RID=F.ID
        LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO G --汇率表
          ON A.CUR = G.BASE_CUR
         AND G.CNV_CUR = 'CNY'
         AND G.DATA_DT = V_P_DATE
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

  END ETL_S_CPTL_INVEST_DIR;
/

