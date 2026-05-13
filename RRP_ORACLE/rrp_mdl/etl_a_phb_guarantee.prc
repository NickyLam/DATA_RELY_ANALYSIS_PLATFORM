CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_GUARANTEE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_GUARANTEE
  *  功能描述：个人及对公信贷业务中所签订的各类担保合同信息，至少包括普通担保和最高额担保合同。
                同一份担保合同有多个担保人的，每个担保人填写一条记录。填报范围包含抵质押合同。
  *  创建日期：20221109
  *  开发人员：徐菲
  *  来源表：M_GUA_COLL_VAL_SPLT A --抵质押物价值拆分表
  *  目标表：A_PHB_GUARANTEE -担保基表_零售
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人     修改原因
  *   1    20221109   xufei      首次创建
  *   2    20230523   liuyu      按照张家伟要求分开抵押质押担保方式
  *   3    20230615   MW         新增贷款分配价值、分配我行确认价值、分配初评我行确认价值字段
  *   4    20231225   HYF        按照张家伟要求担保方式展示为统计担保方式
  *   5    20251013   YJY        押品重构需求，调整数据取数来源
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_GUARANTEE';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_GUARANTEE'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期



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

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO A_PHB_GUARANTEE NOLOGGING
  (
        BGRQ       --1  报告日期
       ,YPWYM      --2  押品唯一码
       ,JYWYM      --3  交易唯一码
       ,ZHWYM      --4  账户唯一码
       ,JGBH       --5  机构编号
       ,JGMC       --6  机构名称
       ,KHWYM      --7  客户唯一码
       ,YPXJLWYM   --8  押品现金流唯一码
       ,SXYWLB     --9  授信业务类别
       ,YPLB       --10 押品类别
       ,YPQSGZCF   --11 押品起始估值拆分（元）
       ,YPZXGZCF   --12 押品最新估值拆分（元）
       ,WJFL       --13 五级分类
       ,CFTJYE     --14 拆分统计余额（元）
       ,TJDBFS     --15 担保方式
       ,SFXXDZYLDK --16 是否新型抵质押类贷款
       ,SFZSCQZY   --17 是否知识产权质押
       ,TJYE       --18 统计余额（元）
       ,YPZXGZ     --19 押品最新估值（元）
       ,YPHSSX     --20 押品缓释上限（元）
       ,DKFPJZ     --21 贷款分配价值
       ,FPWHQRJZ   --22 分配我行确认价值
       ,FPCPWHQRJZ --23 分配初评我行确认价值
   )
  /* SELECT  
            A.DATA_DT     AS BGRQ       --1  报告日期
           ,A.SCCODE       AS YPWYM      --2  押品唯一码
           ,A.CREDNO       AS JYWYM      --3  交易唯一码
           ,B.CONT_ID     AS ZHWYM      --4  账户唯一码
           ,B.ORG_ID       AS JGBH       --5  机构编号
           ,E.ORG_NM       AS JGMC       --6  机构名称
           ,B.CUST_ID     AS KHWYM      --7  客户唯一码
           ,A.SCCODE || '.' || A.CREDNO      AS YPXJLWYM   --8  押品现金流唯一码
           ,'各项贷款'                        AS SXYWLB     --9 授信业务类别
           ,D.TAR_VALUE_NAME                  AS YPLB       --10 押品类别
           ,A.FIRSTCONFMAMT                  AS YPQSGZCF   --11 押品起始估值拆分（元）
           ,A.CONFMAMT                        AS YPZXGZCF   --12 押品最新估值拆分（元）
           ,DECODE(B.LVL5_CL,'01','正常',
                             '02','关注',
                             '03','次级',
                             '04','可疑',
                             '05','损失','不适用')   AS WJFL       --13 五级分类
           ,A.DISTVALUE                              AS CFTJYE     --14 拆分统计余额（元）
           --,DECODE(B.GUA_MODE,'1','抵押','2','质押','3','保证','4','信用','不适用')-- mod by liuyu 20230523 取主担保方式
           ,DECODE(B.TJDBFS,'DZY','抵质押','BZ','保证','XY','信用','不适用')
                                                     AS TJDBFS     --15 担保方式
           ,CASE WHEN C.COLL_TYP IN ('A0501','A0502','D01','D0501','A06','D0502','D0503','D0504')
                                            --上市股票，非上市股权 ，存货、仓单和提单，专利权 保单 商标权 著作权 其他知识产权
                    THEN '是'
                      ELSE '否'
                   END                       AS SFXXDZYLDK --16 是否新型抵质押类贷款
           ,CASE WHEN C.COLL_TYP IN ('D0501','D0502','D0503','D0504')
                    THEN '是'
                      ELSE '否'
                   END                       AS SFZSCQZY   --17 是否知识产权质押
           ,B.LOAN_NET_VAL * F.EXRT         AS TJYE       --18 统计余额（元）
           ,C.BANK_IDNT_PRC_VAL             AS YPZXGZ     --19 押品最新估值（元）
           , CASE WHEN NVL(A.CONFMAMT,0) > NVL(B.LOAN_NET_VAL,0)
                  THEN NVL(B.LOAN_NET_VAL,0) * F.EXRT  --押品价值>本金+利息    取本金+利息总和
                  WHEN NVL(A.CONFMAMT,0) < NVL(B.LOAN_NET_VAL,0)
                  THEN NVL(B.LOAN_NET_VAL,0) * F.EXRT  --押品价值<本金，取本金
                  ELSE 0
              END                      AS YPHSSX     --20 押品缓释上限（元）
         ,A.DISTVALUE             AS DKFPJZ     --21 贷款分配价值
         ,A.CONFMAMT              AS FPWHQRJZ   --22 分配我行确认价值
         ,A.FIRSTCONFMAMT         AS FPCPWHQRJZ --23 分配初评我行确认价值
   FROM RRP_MDL.S_MIMS_YP_GUARDSITRIBUTEFORJOUR/ A --按业务规则分配G13结果表
       INNER JOIN RRP_MDL.S_LOAN B --贷款业务整合表
              ON B.RCPT_ID = A.CREDNO
              AND B.DATA_DT = V_P_DATE
              AND B.DATA_SRC IN ('零售贷款','联合网贷')
       INNER JOIN RRP_MDL.M_GUA_COLL_INFO C --抵质押物详细信息
             ON C.COLL_ID = A.SCCODE
             AND C.DATA_DT =V_P_DATE
              --AND C.COLL_STAT = '01' --正常
             AND (C.INSTO_STATUS_CD IN('02','03')
               OR (C.COL_TYPE_ID LIKE 'ZY0102%' AND NVL(C.BANK_IDNT_PRC_VAL,0) <>0 ))
       LEFT JOIN RRP_MDL.CODE_MAP D
            ON D.SRC_VALUE_CODE  = C.COLL_TYP
            AND D.SRC_CLASS_CODE = 'T0008'  --押品类型
            AND D.MOD_FLG = 'EAST'
       LEFT JOIN RRP_MDL.M_PUM_ORG_INFO E --机构表
            ON E.ORG_ID = B.ORG_ID
            AND E.DATA_DT = V_P_DATE
       LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO F  --汇率表
             ON B.CUR = F.BASE_CUR
             AND F.CNV_CUR='CNY'
             AND F.DATA_DT=V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
         AND (B.LOAN_NET_VAL > 0 OR SUBSTR(B.LOAN_ACT_DSTR_DT,1，4) = SUBSTR(V_P_DATE,1,4)); */
  
  --MOD BY YJY 20251013 押品重构，更换取数来源
  SELECT  
            V_P_DATE                            AS BGRQ       --1  报告日期
           ,A.ASSET_ID                          AS YPWYM      --2  押品唯一码
           ,A.DUBIL_ID                          AS JYWYM      --3  交易唯一码
           ,B.CONT_ID                           AS ZHWYM      --4  账户唯一码
           ,B.ORG_ID                            AS JGBH       --5  机构编号
           ,E.ORG_NM                            AS JGMC       --6  机构名称
           ,B.CUST_ID                           AS KHWYM      --7  客户唯一码
           ,A.ASSET_ID || '.' || A.DUBIL_ID     AS YPXJLWYM   --8  押品现金流唯一码
           ,'各项贷款'                          AS SXYWLB     --9 授信业务类别
           ,D.TAR_VALUE_NAME                    AS YPLB       --10 押品类别
           ,A1.HXB_PA_CFM_VAL                   AS YPQSGZCF   --11 押品起始估值拆分（元）
           ,A1.HXB_CFM_VAL                      AS YPZXGZCF   --12 押品最新估值拆分（元）
           ,DECODE(B.LVL5_CL,'01','正常',
                             '02','关注',
                             '03','次级',
                             '04','可疑',
                             '05','损失',
                             '不适用')           AS WJFL       --13 五级分类
           ,A.LOAN_ASSIGN_BAL                    AS CFTJYE     --14 拆分统计余额（元）
           ,DECODE(B.TJDBFS,'DZY','抵质押',
                            'BZ','保证',
                            'XY','信用',
                            '不适用')
                                                 AS TJDBFS     --15 担保方式
          -- ,CASE WHEN C.COLL_TYP IN ('A0501','A0502','D01','D0501','A06','D0502','D0503','D0504')   
           ,CASE WHEN C.COLL_TYP IN ('A0501','A0502','D0101','D0102','D0103','A06','D070101','D070102','D070103')                                            
                 THEN '是'  --上市股票，非上市股权 ，存货、仓单和提单，保单 专利权  商标权 著作权 其他知识产权
                 ELSE '否'
             END                                 AS SFXXDZYLDK --16 是否新型抵质押类贷款
           ,CASE WHEN C.COLL_TYP IN ('D0501','D0502','D0503','D0504')
                 THEN '是'
                 ELSE '否'
             END                                 AS SFZSCQZY   --17 是否知识产权质押
           ,B.LOAN_NET_VAL * F.EXRT              AS TJYE       --18 统计余额（元）
           ,C.BANK_IDNT_PRC_VAL                  AS YPZXGZ     --19 押品最新估值（元）
           , CASE WHEN NVL(A1.HXB_CFM_VAL,0) > NVL(B.LOAN_NET_VAL,0)
                  THEN NVL(B.LOAN_NET_VAL,0) * F.EXRT  --押品价值>本金+利息    取本金+利息总和
                  WHEN NVL(A1.HXB_CFM_VAL,0) < NVL(B.LOAN_NET_VAL,0)
                  THEN NVL(B.LOAN_NET_VAL,0) * F.EXRT  --押品价值<本金，取本金
                  ELSE 0
              END                                AS YPHSSX     --20 押品缓释上限（元）
         ,A.LOAN_ASSIGN_BAL                      AS DKFPJZ     --21 贷款分配价值
         ,A1.HXB_CFM_VAL                         AS FPWHQRJZ   --22 分配我行确认价值
         ,A1.HXB_PA_CFM_VAL                      AS FPCPWHQRJZ --23 分配初评我行确认价值
   FROM RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H A  --资产借据分配历史
   LEFT JOIN RRP_MDL.O_IML_AST_COL_VAL_INFO_H A1   --押品价值信息历史
     ON A1.ASSET_ID = A.ASSET_ID
    AND A1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN RRP_MDL.S_LOAN B --贷款业务整合表
     ON B.RCPT_ID = A.DUBIL_ID
    AND B.DATA_DT = V_P_DATE
    AND B.DATA_SRC IN ('零售贷款','联合网贷')
  INNER JOIN RRP_MDL.M_GUA_COLL_INFO C --抵质押物详细信息
     ON C.COLL_ID = A.ASSET_ID
    AND C.DATA_DT =V_P_DATE
    AND (C.INSTO_STATUS_CD IN('02','03')
         --OR (C.COL_TYPE_ID LIKE 'ZY0102%' AND NVL(C.BANK_IDNT_PRC_VAL,0) <>0 ))
         OR (C.COL_TYPE_ID LIKE '9901001%' AND NVL(C.BANK_IDNT_PRC_VAL,0) <>0 ))
   LEFT JOIN RRP_MDL.CODE_MAP D
     ON D.SRC_VALUE_CODE  = C.COLL_TYP
    AND D.SRC_CLASS_CODE = 'T0008'  --押品类型
    AND D.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.M_PUM_ORG_INFO E --机构表
     ON E.ORG_ID = B.ORG_ID
    AND E.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO F  --汇率表
     ON B.CUR = F.BASE_CUR
    AND F.CNV_CUR = 'CNY'
    AND F.DATA_DT = V_P_DATE
  WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') 
    AND (B.LOAN_NET_VAL > 0 OR SUBSTR(B.LOAN_ACT_DSTR_DT,1，4) = SUBSTR(V_P_DATE,1,4));        
         
  COMMIT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 -- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,YPXJLWYM,COUNT(1)
      FROM RRP_MDL.A_PHB_GUARANTEE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,YPXJLWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP      := V_STEP + 1;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_GUARANTEE;
/

