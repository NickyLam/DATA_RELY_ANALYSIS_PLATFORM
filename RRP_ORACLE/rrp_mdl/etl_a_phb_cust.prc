CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_CUST
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_CUST
  *  功能描述：个人客户的基本信息。包括本行客户及本行客户的担保、配偶、亲属关系所涉及到的个人信息。
                以个人名义登记客户资料的个体工商户、私营业主应纳入本表填报范围。
  *  创建日期：20221104
  *  开发人员：徐菲
  *  来源表： M_CUST_IND_INFO A --监管集市自然人客户基本信息
  *  目标表：A_PHB_CUST --客户基表_零售
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221104   xufei      首次创建
  *   2    20230707   mw         客户所属行业改为从补录后的S_LOAN表取数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_CUST';
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
  V_TAB_NAME := 'A_PHB_CUST'; --表名,写目标表表名
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

    INSERT INTO A_PHB_CUST
    (
        BGRQ          --报告日期
       ,KHWYM         --客户唯一码
       ,KHMC          --客户名称
       ,GRKHZJLX      --个人客户证件类型
       ,ZJHM          --证件号码
       ,GRKHSFZDZ     --个人客户身份证地址
       ,GRKHHKBDZ     --个人客户户口薄地址
       ,GRKHCZD       --个人客户常住地
       ,GRKHATJFL     --个人客户按统计分类
       ,KHSZSJXZQ     --客户所在省级行政区
       ,KHSZDJXZQ     --客户所在地级行政区
       ,KHSZXJXZQ     --客户所在县级行政区
       ,KHSZDXZQHDM   --客户所在地行政区划代码
       ,SSGMJJXYMLMC  --所属国民经济行业门类名称
       ,SSGMJJXYDLMC  --所属国民经济行业大类名称
       ,SSGMJJXYZLMC  --所属国民经济行业中类名称
       ,SSGMJJXYXLMC  --所属国民经济行业小类名称
       ,SSGMJJXYXLDM  --所属国民经济行业小类代码
       ,SFJTNC        --是否家庭农场
       ,SFNH          --是否农户
       ,SFDBH         --是否低保户
       ,NL            --年龄
       ,JKRNLQJ       --借款人年龄区间
       ,SFBYYZPRK     --是否边缘易致贫人口
       ,KHSFWYYTPDQ   --客户是否位于已脱贫地区
       ,KHSFWYCDBFX   --客户是否位于重点帮扶县
       ,KHSFWYXY      --客户是否位于县域
       ,SFCJR         --是否残疾人
       ,CSRQ          --出生日期  --add by weiyongzhao 20220822
    )
      SELECT  A.DATA_DT        AS BGRQ          --报告日期
             ,A.CUST_ID        AS KHWYM         --客户唯一码
             ,A.CUST_NM        AS KHMC          --客户名称
             ,D.SRC_VALUE_NAME AS GRKHZJLX      --个人客户证件类型
             ,A.CRDL_NO        AS ZJHM          --证件号码
             ,A.CRDL_ADDR      AS GRKHSFZDZ     --个人客户身份证地址
             ,A.CRDL_ADDR      AS GRKHHKBDZ     --个人客户户口薄地址
             ,A.RSDNC_ADDR     AS GRKHCZD       --个人客户常住地
             ,DECODE(C.OPR_CUST_TYP,'B','小微企业主','A','个体工商户','不适用')
                               AS GRKHATJFL     --个人客户按统计分类
             ,SUBSTR(A.RSDNC_AREA_CD,1,2)||'0000'          AS KHSZSJXZQ     --客户所在省级行政区
             ,SUBSTR(A.RSDNC_AREA_CD,1,4)||'00'            AS KHSZDJXZQ     --客户所在地级行政区
             ,A.RSDNC_AREA_CD                              AS KHSZXJXZQ     --客户所在县级行政区
             ,A.RSDNC_AREA_CD                              AS KHSZDXZQHDM   --客户所在地行政区划代码
             ,H.SRC_VALUE_NAME                             AS SSGMJJXYMLMC  --所属国民经济行业门类名称
             ,G.SRC_VALUE_NAME                             AS SSGMJJXYDLMC  --所属国民经济行业大类名称
             ,F.SRC_VALUE_NAME                             AS SSGMJJXYZLMC  --所属国民经济行业中类名称
             ,E.SRC_VALUE_NAME                             AS SSGMJJXYXLMC  --所属国民经济行业小类名称
             ,A.CUST_BLNG_IDY                              AS SSGMJJXYXLDM  --所属国民经济行业小类代码
             ,'否'                                         AS SFJTNC        --是否家庭农场
             ,DECODE(A.FARM_FLG,'Y','是','否')             AS SFNH          --是否农户
             ,'否'                                         AS SFDBH         --是否低保户
             ,A.AGE                                        AS NL            --年龄
             ,CASE WHEN A.AGE <= 25 THEN '25岁（含）以下'  --25岁（含）以下
                   WHEN A.AGE <= 35 THEN '25岁-35岁（含）'  --25岁-35岁（含）
                   WHEN A.AGE <= 45 THEN '35岁-45岁（含）'  --35岁-45岁（含）
                   WHEN A.AGE <= 55 THEN '45岁-55岁（含）'  --45岁-55岁（含）
                   ELSE '55岁以上'                   --55岁以上
              END                                          AS JKRNLQJ       --借款人年龄区间
             ,'否'                                         AS SFBYYZPRK     --是否边缘易致贫人口
             ,'否'                                         AS KHSFWYYTPDQ   --客户是否位于已脱贫地区
             ,DECODE(C.POV_ALLE_CNTY_FLG,'Y','是','否')    AS KHSFWYCDBFX   --客户是否位于重点帮扶县
             ,DECODE(C.CNTY_DMN_RGN_FLG,'Y','是','否')     AS KHSFWYXY      --客户是否位于县域
             ,'否'                                         AS SFCJR         --是否残疾人
             ,A.BIRTH_DT                                   AS CSRQ          --出生日期
         FROM RRP_MDL.M_CUST_IND_INFO A
        INNER JOIN (SELECT T1.CUST_ID,
                           MAX(CNTY_DMN_RGN_FLG) AS CNTY_DMN_RGN_FLG, --县域地区标志
                           MAX(ALDY_OFF_POV_RGN_FLG) AS ALDY_OFF_POV_RGN_FLG, --已脱贫地区标志
                           MAX(POV_ALLE_CNTY_FLG) AS POV_ALLE_CNTY_FLG, --重点帮扶县标志
                           MAX(OPR_CUST_TYP) AS OPR_CUST_TYP, --经营性客户类型
                           MAX(CASE WHEN CUST_BLNG_IDY IN (' ','-') THEN NULL
                                    ELSE CUST_BLNG_IDY END ) AS CUST_BLNG_IDY
                      FROM RRP_MDL.S_LOAN T1 -- 贷款业务整合表
                     WHERE T1.DATA_SRC IN ('零售贷款', '联合网贷')
                       AND (T1.DATA_DT = V_P_DATE AND
                           (T1.LOAN_BAL <> 0 OR
                           SUBSTR(T1.LOAN_ACT_DSTR_DT, 1, 4) =
                           SUBSTR(V_P_DATE, 1, 4) OR
                           (T1.DATA_SRC IN ('联合网贷') AND
                           T1.LOAN_ACT_DSTR_DT =
                           TO_CHAR(TO_DATE(SUBSTR(V_P_DATE, 1, 4) || '0101',
                                              'YYYYMMDD') - 1,
                                      'YYYYMMDD'))) OR
                           (T1.DATA_DT =
                           TO_CHAR(TO_DATE(SUBSTR(V_P_DATE, 1, 4) || '0101',
                                             'YYYYMMDD') - 1,
                                     'YYYYMMDD') AND T1.LOAN_BAL <> 0))
                     GROUP BY T1.CUST_ID) C
           ON C.CUST_ID = A.CUST_ID
         LEFT JOIN RRP_MDL.CODE_MAP D --码值映射表
           ON A.CRDL_TYP = D.SRC_VALUE_CODE
          AND D.SRC_CLASS_CODE = 'C0001' --个人客户证件类型
          AND D.TAR_CLASS_CODE = 'C0001' --个人客户证件类型
          AND D.MOD_FLG = 'EAST'
         LEFT JOIN RRP_MDL.CODE_MAP E --码值映射表
           ON C.CUST_BLNG_IDY = E.SRC_VALUE_CODE
          AND E.SRC_CLASS_CODE = 'P0003' --行业类别 小类
          AND E.TAR_CLASS_CODE = 'P0003' --行业类别
          AND E.MOD_FLG = 'MDM'
         LEFT JOIN RRP_MDL.CODE_MAP F --码值映射表
           ON SUBSTR(TRIM(C.CUST_BLNG_IDY), 1, 4) = F.SRC_VALUE_CODE
          AND F.SRC_CLASS_CODE = 'P0003' --行业类别 中类
          AND F.TAR_CLASS_CODE = 'P0003' --行业类别
          AND F.MOD_FLG = 'MDM'
         LEFT JOIN RRP_MDL.CODE_MAP G --码值映射表
           ON SUBSTR(TRIM(C.CUST_BLNG_IDY), 1, 3) = G.SRC_VALUE_CODE
          AND G.SRC_CLASS_CODE = 'P0003' --行业类别 大类
          AND G.TAR_CLASS_CODE = 'P0003' --行业类别
          AND G.MOD_FLG = 'MDM'
         LEFT JOIN RRP_MDL.CODE_MAP H --码值映射表
           ON SUBSTR(TRIM(C.CUST_BLNG_IDY), 1, 1) = H.SRC_VALUE_CODE
          AND H.SRC_CLASS_CODE = 'P0003' --行业类别 门类
          AND H.TAR_CLASS_CODE = 'P0003' --行业类别
          AND H.MOD_FLG = 'MDM'
        WHERE A.DATA_DT = V_P_DATE;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,KHWYM,COUNT(1)
      FROM RRP_MDL.A_PHB_CUST T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,KHWYM
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

  END ETL_A_PHB_CUST;
/

