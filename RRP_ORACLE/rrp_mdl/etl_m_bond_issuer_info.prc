CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_BOND_ISSUER_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_M_BOND_ISSUER_INFO
  *  功能描述：债券发行人信息
  *  创建日期：20221031
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_BOND_ISSUER_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221031 梅炜      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                 --处理步骤
  V_P_DATE    VARCHAR2(8);                  --跑批数据日期
  V_STARTTIME DATE;                         --处理开始时间
  V_ENDTIME   DATE;                         --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                 --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                --任务名称
  V_PART_NAME VARCHAR2(100);                --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_BOND_ISSUER_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_BOND_ISSUER_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';   --来源系统 --默认写监管报送系统，有真实来源的按实际写
  --V_LAST_DAT  VARCHAR2(8);                  --当月月末
  --V_YESTADAY  VARCHAR2(8);                  --上日
  --V_MONTH_START_DATE DATE;                  --系统时间对应月初日期
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_BOND_ISSUER_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'ETL_M_BOND_ISSUER_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
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
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入债券发行人信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_BOND_ISSUER_INFO
    (DATA_DT              --数据日期
    ,LGL_REP_ID           --法人编号
    ,CUST_ID              --客户号
    ,CUST_NM              --客户中文名称
    ,CUST_NM_EN           --客户英文名称
    ,BIO_FLG              --境内外标志
    ,CUST_TYP             --客户大类
    ,RG_CD                --客户所属地区
    ,ID_NO                --证件号码
    ,ORG_ID               --机构编号
    ,NATION_CD            --国籍或注册地国家代码
    ,RESIDENT_FLG         --居民标志
    ,NATION_CD1           --住所或经营所在地国家代码
    ,RELA_TYP             --关联方类型
    ,STOCK_PCT            --持股比例
    ,BUSI_RELA_TYP        --业务关系类型
    ,DEPTLINE             --部门条线
    ,DATA_SRC             --数据来源
    )
  SELECT V_P_DATE                              AS DATA_DT            --数据日期
        ,A.LP_ID                               AS LGL_REP_ID          --法人编号
        ,A.ISSUER_ID                           AS CUST_ID             --客户号
        ,A.CN_NAME                             AS CUST_NM             --客户中文名称
        ,A.EN_NAME                             AS CUST_NM_EN          --客户英文名称
        ,'Y'                                   AS BIO_FLG             --境内外标志
        ,'12'                                  AS CUST_TYP            --客户大类
        ,CASE WHEN A.CN_NAME = '西藏自治区政府' THEN '540000'
              WHEN A.CN_NAME = '安徽省政府' THEN '340000'
              WHEN A.CN_NAME = '北京市政府' THEN '110000'
              WHEN A.CN_NAME = '大连市政府' THEN '210200'
              WHEN A.CN_NAME = '福建省政府' THEN '350000'
              WHEN A.CN_NAME = '甘肃省政府' THEN '620000'
              WHEN A.CN_NAME = '广东省政府' THEN '440000'
              WHEN A.CN_NAME = '广西壮族自治区政府' THEN '450000'
              WHEN A.CN_NAME = '贵州省政府' THEN '520000'
              WHEN A.CN_NAME = '海南省政府' THEN '460000'
              WHEN A.CN_NAME = '河北省政府' THEN '130000'
              WHEN A.CN_NAME = '河南省政府' THEN '410000'
              WHEN A.CN_NAME = '黑龙江省政府' THEN '230000'
              WHEN A.CN_NAME = '湖北省政府' THEN '420000'
              WHEN A.CN_NAME = '湖南省政府' THEN '430000'
              WHEN A.CN_NAME = '吉林省政府' THEN '220000'
              WHEN A.CN_NAME = '江苏省政府' THEN '320000'
              WHEN A.CN_NAME = '江西省政府' THEN '360000'
              WHEN A.CN_NAME = '辽宁省政府' THEN '210000'
              WHEN A.CN_NAME = '内蒙古自治区政府' THEN '150000'
              WHEN A.CN_NAME = '宁波市政府' THEN '330200'
              WHEN A.CN_NAME = '宁夏回族自治区政府' THEN '640000'
              WHEN A.CN_NAME = '青岛市政府' THEN '3702'
              WHEN A.CN_NAME = '青海省政府' THEN '630000'
              WHEN A.CN_NAME = '山东省政府' THEN '370000'
              WHEN A.CN_NAME = '山西省政府' THEN '140000'
              WHEN A.CN_NAME = '陕西省政府' THEN '610000'
              WHEN A.CN_NAME = '上海市政府' THEN '310000'
              WHEN A.CN_NAME = '深圳市政府' THEN '440300'
              WHEN A.CN_NAME = '四川省政府' THEN '510000'
              WHEN A.CN_NAME = '天津市政府' THEN '120000'
              WHEN A.CN_NAME = '厦门市政府' THEN '350200'
              WHEN A.CN_NAME = '新疆维吾尔自治区政府' THEN '650000'
              WHEN A.CN_NAME = '云南省政府' THEN '530000'
              WHEN A.CN_NAME = '浙江省政府' THEN '330000'
              WHEN A.CN_NAME = '重庆市政府' THEN '500000'
              ELSE ''
          END                                   AS RG_CD               --客户所属地区
        ,NULL                                   AS ID_NO               --证件号码
        ,NULL                                   AS ORG_ID              --机构编号
        ,'CHN'                                  AS NATION_CD           --国籍或注册地国家代码
        ,'1'                                    AS RESIDENT_FLG        --居民标志
        ,NVL(B.OPERATED_COUNTRY,'CHN')          AS NATION_CD1          --住所或经营所在地国家代码
        ,NULL                                   AS RELA_TYP            --关联方类型
        ,NULL                                   AS STOCK_PCT           --持股比例
        ,'111'                                  AS BUSI_RELA_TYP       --业务关系类型  '111'->无结算业务、无理财业务、无咨询业务
        ,'资金发行人'                           AS DEPTLINE            --部门条线
        ,'债券发行人信息'                       AS DATA_SRC            --数据来源
    FROM RRP_MDL.O_IML_PTY_BOND_ISSUER_INFO A  --债券发行人信息
    /*LEFT JOIN (SELECT T1.OPERATED_COUNTRY,T1.ASSET_NAME,B.ISSUER_CD FROM RRP_MDL.S_IOL_RDW_DCM_FORECURR_DEBT_SENSITIV T1
    LEFT JOIN RRP_MDL.S_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息表
      ON B.BOND_ID = T1.LOAN_REF_NO
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) B*/ --ADD BY HAP 20210125 取财务集市补录表的经营地
    LEFT JOIN (SELECT * 
                 FROM( SELECT T.*,ROW_NUMBER() OVER(PARTITION BY ISSUER_CD ORDER BY OPERATED_COUNTRY ) AS RN
                         FROM (SELECT T1.OPERATED_COUNTRY,T1.ASSET_NAME,B.ISSUER_CD
                                 FROM RRP_MDL.ADD_DCM_FORECURR_DEBT_SENSITIV T1
                                 LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B
                                   ON B.BOND_ID = T1.LOAN_REF_NO
                                  AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))T)
                WHERE RN = 1)B
      ON B.ISSUER_CD = A.ISSUER_ID
    WHERE /*A.ISSUER_ID NOT IN (SELECT C.ISSUER_ID
                                FROM RRP_MDL.S_IML_PTY_CAP_CNTPTY_INFO C --资金交易对手信息
                               WHERE C.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                               )--与SP_L_CUST_C 条件保持一致，不然会漏掉数据 BY HAP 20201207
      AND*/ A.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_BOND_ISSUER_INFO;
/

