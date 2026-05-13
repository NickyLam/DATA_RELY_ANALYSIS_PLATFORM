CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_DEP_FUND(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_DEP_FUND
  *  功能描述：委托贷款基金整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *            M_DEP_ACC_INFO
  *
  *
  *
  *
  *  目标表：  S_DEP_FUND
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_DEP_FUND'; -- 程序名称
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
  V_TAB_NAME := 'S_DEP_FUND'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_DEP_FUND T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_DEP_FUND'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '委托贷款基金整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_DEP_FUND
      ( DATA_DT            --数据日期
       ,LGL_REP_ID         --法人编号
       ,ORG_ID             --机构编号
       ,DEP_ACC            --存款账号
       ,CONSR_ID           --委托人编号
       ,ENTRS_LOAN_TYP     --委托贷款类型
       ,CONSR_TYP          --委托人类型
       ,HPF_ENTRS_FUND_FLG --住房公积金委托基金标志
       ,BIZ_CUR            --业务币种
       ,DEP_BAL            --存款余额
       ,DEPT_LINE          --部门条线
       ,DATA_SRC           --数据来源
       )
      SELECT  A.DATA_DT                                            AS DATA_DT    --数据日期
             ,A.LGL_REP_ID                                         AS LGL_REP_ID --法人编号
             ,A.ORG_ID                                             AS ORG_ID     --机构编号
             ,A.ACC_ID                                             AS DEP_ACC    --存款账号
             ,A.CUST_ID                                            AS CONSR_ID   --委托人编号
             ,A.ENTRS_LOAN_FUND_SUM_CL                             AS ENTRS_LOAN_TYP --委托贷款类型
             ,CASE WHEN B.RSDNT_FLG = 'N' OR C.RSDNT_FLG = 'N' THEN 'B04' --境外
                   WHEN B.CUST_ID IS NOT NULL THEN 'B03' --个人
                   WHEN C.FIN_ORG_TYP = 'A10000' THEN 'A01' --中央银行
                   WHEN C.FIN_ORG_TYP LIKE 'C%' THEN 'A02' --存款类金融机构
                   WHEN C.FIN_ORG_TYP LIKE 'D%' THEN 'A03' --非存款类金融机构
                   WHEN C.FIN_ORG_TYP LIKE 'E%' THEN 'A04' --证券业金融机构
                   WHEN C.FIN_ORG_TYP LIKE 'F%' THEN 'A05' --保险业金融机构
                   WHEN A.CONSR_TYP = '05' THEN 'A06' --特殊目的载体
                   WHEN C.FIN_ORG_TYP IS NOT NULL THEN 'A07' --其他金融机构
                   WHEN SUBSTR(C.CUST_CL, 1, 1) IN ('B', --政府机关
                                                    'C', --事业单位
                                                    'D', --社会团体
                                                    'F', --部队
                                                    'G', --社保基金
                                                    'H' --住房公积金
                                                   ) 
                   THEN 'B01' --广义政府
                   ELSE 'B02' --企业及各类组织
               END                                                   AS CONSR_TYP --委托人类型
             ,CASE WHEN C.CUST_CL LIKE 'H%' THEN 'Y'
                   ELSE 'N'
               END                                                   AS HPF_ENTRS_FUND_FLG --住房公积金委托基金标志
             ,A.CUR                                                  AS BIZ_CUR       --业务币种
             ,A.DEP_BAL                                              AS DEP_BAL       --存款余额
             ,A.DEPT_LINE                                            AS DEPT_LINE     --部门条线
             ,A.DATA_SRC                                             AS DATA_SRC      --数据来源
        FROM RRP_MDL.M_DEP_ACC_INFO A --存款账户信息
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO B --个人客户信息
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.ENTRS_LOAN_FUND_SUM_CL IN ('9011', '9012')
         AND A.DATA_DT = V_P_DATE;
         
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

  END ETL_S_DEP_FUND;
/

