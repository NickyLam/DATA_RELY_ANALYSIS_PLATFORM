CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_ORG
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
/**************************************************************************
  *  程序名称：ETL_A_PHB_ORG
  *  功能描述：零售-报送机构小基表
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_PHB_ORG           --零售-报送机构小基表
  *  配置表：
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   WYX      首次创建
***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_ORG';   --程序名称
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
  V_TAB_NAME   := 'A_PHB_ORG'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '零售-报送机构小基表';
  V_STARTTIME := SYSDATE;

    INSERT INTO A_PHB_ORG
    (
       BGRQ           --报告日期
      ,NBJGH          --内部机构号
      ,SSFXBH         --所属分行编号
      ,SSFXMC         --所属分行名称
      ,YXJGMC         --银行机构名称
      ,SSJGJG         --所属监管机构
      ,JGSZSJXZQ      --机构所在省级行政区
      ,JGSFWYXY       --机构是否位于县域
      ,JGSZXYMC       --机构所在县域名称
      ,JGSZXYXZQHDM   --机构所在县域行政区划代码
      ,JGSFWYYTPDQ    --机构是否位于已脱贫地区
      ,YTPDQMC        --已脱贫地区名称
      ,YTPDQDM        --已脱贫地区代码
      ,JGSFWYCDBFX    --机构是否位于重点帮扶县
      ,CDBFXMC        --重点帮扶县名称
      ,CDBFXDM        --重点帮扶县代码
      ,SFYGADWQ       --是否粤港澳大湾区
      ,SFZMQ          --是否自贸区
      ,SZZMQMC        --所在自贸区名称
    )
    SELECT V_P_DATE                         AS BGRQ               --报告日期
          ,A.ORG_ID                         AS NBJGH              --内部机构号
          ,B.ORG_ID                         AS SSFXBH             --所属分行编号
          ,B.ORG_NAME                       AS SSFXMC             --所属分行名称
          ,A.ORG_NAME                       AS YXJGMC             --银行机构名称
          ,CASE WHEN A.ORG_ID LIKE '801%' THEN '广东省局'               --广东省局
                WHEN A.ORG_ID LIKE '805%' THEN '深圳局'             --深圳局
                WHEN A.ORG_ID LIKE '802%' OR A.ORG_ID LIKE '800%' OR A.ORG_ID LIKE '89%' THEN '汕头分局' --深圳局
                WHEN A.ORG_ID LIKE '803%' THEN '佛山分局'      --佛山分局
                WHEN A.ORG_ID LIKE '806%' THEN '东莞分局'      --东莞分局
                WHEN A.ORG_ID LIKE '807%' THEN '中山分局'      --中山分局
                WHEN A.ORG_ID LIKE '808%' THEN '江门分局'      --江门分局
                WHEN A.ORG_ID LIKE '809%' THEN '珠海分局'      --珠海分局
                WHEN A.ORG_ID LIKE '810%' THEN '惠州分局'      --惠州分局
                WHEN A.ORG_ID LIKE '811%' THEN '肇庆分局'      --肇庆分局
                WHEN A.ORG_ID LIKE '812%' THEN '湛江分局'      --湛江分局
                END                         AS SSJGJG      --所属监管机构
          ,'广东省'                         AS JGSZSJXZQ   --机构所在省级行政区
          ,CASE WHEN A.ORG_ID IN ('808041','808050','808051') THEN '是' ELSE '否' END AS JGSFWYXY   --机构是否位于县域
          ,CASE WHEN A.ORG_ID IN ('808041') THEN '鹤山市'
                WHEN A.ORG_ID IN ('808050','808051') THEN '开平市'
                END                          AS JGSZXYMC    --机构所在县域名称
          ,CASE WHEN A.ORG_ID IN ('808041','808050','808051') THEN
                CASE WHEN A.COUNTY_CD IS NOT NULL AND A.COUNTY_CD <> ' ' THEN A.COUNTY_CD
                     WHEN A.CITY_CD IS NOT NULL AND A.CITY_CD <> ' ' THEN A.CITY_CD
                     WHEN A.PROV_CD IS NOT NULL AND A.PROV_CD <> ' ' THEN A.PROV_CD
                     END
                END AS JGSZXYXZQHDM              --机构所在县域行政区划代码
          ,'否' AS JGSFWYYTPDQ                   --机构是否位于已脱贫地区
          ,''   AS YTPDQMC                       --已脱贫地区名称
          ,''   AS YTPDQDM                       --已脱贫地区代码
          ,'否' AS JGSFWYCDBFX                   --机构是否位于重点帮扶县
          ,''   AS CDBFXMC                       --重点帮扶县名称
          ,''   AS CDBFXDM                       --重点帮扶县代码
          ,CASE WHEN SUBSTR(A.ORG_ID,1,3) IN ('801','803','805','806','807','808','809','810','811') THEN '是' ELSE '否' END AS SFYGADWQ   --是否粤港澳大湾区
          ,CASE WHEN A.ORG_ID IN ('801061','805081') THEN '是' ELSE '否' END AS SFZMQ                                                      --是否自贸区
          ,CASE WHEN A.ORG_ID IN ('801061','805081') THEN '中国（广东）自由贸易试验区' ELSE '不适用' END AS SZZMQMC                        --所在自贸区名称
    FROM O_ICL_CMM_INTNAL_ORG_INFO A                 --内部机构信息
    LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B            --内部机构信息
        ON B.ORG_ID = SUBSTR(A.ORG_ID,1,3)           --机构前3位是分行
        AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    INNER JOIN (SELECT DISTINCT ORG_ID
                FROM M_LOAN_IN_DUBILL_INFO
                WHERE DATA_DT=V_P_DATE
                ) C
          ON A.ORG_ID=C.ORG_ID    --只取借据表有的机构
    WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
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
    SELECT BGRQ,NBJGH,COUNT(1)
      FROM RRP_MDL.A_PHB_ORG T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,NBJGH
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
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_A_PHB_ORG;
/

