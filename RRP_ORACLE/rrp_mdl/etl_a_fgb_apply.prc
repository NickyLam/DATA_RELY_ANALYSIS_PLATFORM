CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_APPLY
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_FGB_APPLY
  *  功能描述：对公-申请客户小基表
  *  取数逻辑：为了S6301的往年申请当年放款的户数+当年申请的户数
     往年申请当年放款的数不太好取出来，基表不出该部分数据，可以直接参考账务基表当年放款数据取数，申请基表不展示。
  *  创建日期：20221107
  *  开发人员：liuyu
  *  来源表：
  *  目标表：A_FGB_APPLY           --对公-申请客户小基表
  *  配置表：
  *  修改情况：
     序号  修改日期   修改人    修改原因
  *   1    20221031   WYX       首次创建
  *   2    20230221   Liuyu     加入当年放款的客户去重取数
  *   3    20230509   liuyu     加入当年放款明细
  *   4    20231008   TZJ       修改去年申请当年发放的申请日期。原来取放款日期作为申请日期
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_APPLY';   --程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_DATE       DATE;
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_DATE       := TO_DATE(I_P_DATE,'YYYYMMDD');
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_FGB_APPLY'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(I_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公-申请客户-申请流水';
  V_STARTTIME := SYSDATE;

   INSERT INTO A_FGB_APPLY
    (
           BGRQ                                   --报告日期
          ,SXSQBH                                 --授信申请编号
          ,SQRQ                                   --申请日期
          ,ZWJGBH                                 --机构编号
          ,ZWJGMC                                 --机构名称
          ,SQKHMC                                 --申请客户名称
          ,SQKHQYGM                               --申请客户企业规模
          ,SQKHEDLX                               --申请客户额度类型
          ,SQZXED                                 --申请专项额度
          ,SJLY                                   --数据来源
          ,FSLX                                   --发生类型
          ,SQKHWYM                                --申请客户唯一码
    )
    SELECT V_P_DATE             AS BGRQ           --报告日期
          ,A.APP_ID             AS SXSQBH         --授信申请编号
          ,A.APP_DT             AS SQRQ           --申请日期
          ,A.ORG_ID             AS ZWJGBH         --机构编号
          ,D.ORG_NM             AS ZWJGMC         --机构名称
          ,B.CUST_NM            AS SQKHMC         --申请客户名称
          ,CASE WHEN B.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
                THEN CASE WHEN B.ENT_SCALE = 'X' THEN '微型'
                          WHEN B.ENT_SCALE = 'S' THEN '小型'
                          WHEN B.ENT_SCALE = 'M' THEN '中型'
                          WHEN B.ENT_SCALE = 'L' THEN '大型'
                      END
                ELSE B.CBRC_CUST_CL
           END                  AS SQKHQYGM       --申请客户企业规模
          ,NVL(C.PROD_NAME,A.LOAN_BIZ_TYP)
                                AS SQKHEDLX       --申请客户额度类型
          ,NVL(C1.PROD_NAME,A.LMT_UNDER_SELLBL_PROD_ID)
                                AS SQZXED         --申请专项额度
          ,CASE WHEN A.DEPT_LINE = '202304报送数据同步' THEN A.DEPT_LINE
                ELSE A.DATA_SRC
           END                  AS SJLY           --数据来源
          ,CASE WHEN A.LOAN_HAPP_TYPE_CD = '0100' THEN '新增'
                WHEN A.LOAN_HAPP_TYPE_CD = '0101' THEN '授信条件变更'
                WHEN A.LOAN_HAPP_TYPE_CD = '0102' THEN '原额度续作'
                WHEN A.LOAN_HAPP_TYPE_CD = '0103' THEN '增额续作'
                WHEN A.LOAN_HAPP_TYPE_CD = '0104' THEN '减额续作'
                WHEN A.LOAN_HAPP_TYPE_CD = '0201' THEN '展期'
                WHEN A.LOAN_HAPP_TYPE_CD = '0202' THEN '借新还旧'
                WHEN A.LOAN_HAPP_TYPE_CD = '0204' THEN '债务重组'
                WHEN A.LOAN_HAPP_TYPE_CD = '0205' THEN '新借'
                WHEN A.LOAN_HAPP_TYPE_CD = '0206' THEN '复议'
                WHEN A.LOAN_HAPP_TYPE_CD = '0207' THEN '年审'
                WHEN A.LOAN_HAPP_TYPE_CD = '0208' THEN '变更借款人'
           END                  AS FSLX           --发生类型
          ,A.CUST_ID            AS SQKHWYM        --申请客户唯一码
      FROM RRP_MDL.S_LOAN_APP A --贷款申请信息整合表
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_PROD_INFO C --信贷产品表
        ON C.PROD_ID = A.LOAN_BIZ_TYP
       AND C.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C1 --贷款产品信息表
        ON C1.PROD_ID = A.LMT_UNDER_SELLBL_PROD_ID
       AND C1.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO D --机构表
        ON D.ORG_ID = A.ORG_ID
       AND D.DATA_DT = V_P_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND A.DATA_SRC = '对公信贷' -- 取对公条线
       AND SUBSTR(A.APP_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) --取申请日期为当年
    ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公-申请客户-放款明细';
  V_STARTTIME := SYSDATE;

   INSERT INTO A_FGB_APPLY
    (
           BGRQ                                   --报告日期
          ,SXSQBH                                 --授信申请编号
          ,SQRQ                                   --申请日期
          ,ZWJGBH                                 --机构编号
          ,ZWJGMC                                 --机构名称
          ,SQKHMC                                 --申请客户名称
          ,SQKHQYGM                               --申请客户企业规模
          ,SQKHEDLX                               --申请客户额度类型
          ,SQZXED                                 --申请专项额度
          ,SJLY                                   --数据来源
          ,FSLX                                   --发生类型
          ,SQKHWYM                                --申请客户唯一码
    )
    SELECT V_P_DATE             AS BGRQ           --报告日期
          ,A.RCPT_ID            AS SXSQBH         --授信申请编号
          --,A.LOAN_ACT_DSTR_DT   AS SQRQ           --申请日期
          ,TO_CHAR(I.APPL_DT,'YYYYMMDD')  AS SQRQ           --申请日期 UPDATE BY TZJ 20231008
          ,A.ORG_ID             AS ZWJGBH         --机构编号
          ,D.ORG_NM             AS ZWJGMC         --机构名称
          ,B.CUST_NM            AS SQKHMC         --申请客户名称
          ,CASE WHEN B.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' )
                THEN CASE WHEN B.ENT_SCALE = 'X' THEN '微型'
                          WHEN B.ENT_SCALE = 'S' THEN '小型'
                          WHEN B.ENT_SCALE = 'M' THEN '中型'
                          WHEN B.ENT_SCALE = 'L' THEN '大型'
                      END
                ELSE B.CBRC_CUST_CL
           END                  AS SQKHQYGM       --申请客户企业规模
          ,''
                                AS SQKHEDLX       --申请客户额度类型
          ,''
                                AS SQZXED         --申请专项额度
          ,'放款明细'           AS SJLY           --数据来源
          ,''                   AS FSLX           --发生类型
          ,A.CUST_ID            AS SQKHWYM        --申请客户唯一码
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --贷款借据整合表
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息
        ON C.CONT_ID = A.CONT_ID
       AND C.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO D --对公授信额度合同审批信息
        ON D.CRDT_LMT_APV_FLOW_NUM = C.APV_FLOW_NUM
       AND D.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO I --对公贷款申请表
        ON I.LOAN_APPL_FLOW_NUM = D.RELA_CRDT_LMT_APV_FLOW_NUM
       AND I.ETL_DT = V_DATE
      LEFT JOIN M_PUM_ORG_INFO D --机构表
        ON D.ORG_ID = A.ORG_ID
       AND D.DATA_DT = V_P_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') -- 取对公条线
       AND SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4) --取放款日期为当年
       AND TRUNC(I.APPL_DT,'Y') = TRUNC(TRUNC(V_DATE,'Y')-1,'Y') -- 取往年申请的
    ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
 WITH TMP1 AS (
  SELECT BGRQ,SXSQBH,COUNT(1)
    FROM RRP_MDL.A_FGB_APPLY T
   WHERE BGRQ = V_P_DATE
   GROUP BY BGRQ,SXSQBH
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
  COMMIT;

     RETURN;
  END IF;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
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
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_A_FGB_APPLY;
/

