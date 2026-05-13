CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_CORP_GRPMBR_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_CORP_GRPMBR_SUB
  *  功能描述：监管集市集团客户成员信息
  *  创建日期：20220609
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息
  *
  *
  *  目标表：  M_CUST_CORP_GRPMBR_SUB  --集团客户成员子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_INIT_M_CUST_CORP_GRPMBR_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_CORP_GRPMBR_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  -- V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入集团客户成员子表数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_CORP_GRPMBR_SUB
  (
   DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,GRP_CUST_ID            --集团客户编号
    ,MBR_NM                 --成员名称
    ,MBR_CUST_ID            --成员客户编号
    ,MBR_TYP                --成员类型
    ,PAR_CO_FLG             --母公司标志
    ,MBR_USCC               --成员统一社会信用代码
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,GRP_CUST_FLG           --集团客户标识
    ,SAIC_REGD_ID           --工商注册标识
  )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')          AS DATA_DT                --数据日期
        ,A.LP_ID                                AS LGL_REP_ID             --法人编号
        ,B.GROUP_CUST_ID                        AS GRP_CUST_ID            --集团客户编号
        ,A.CUST_NAME                            AS MBR_NM                 --成员名称
        ,A.CUST_ID                              AS MBR_CUST_ID            --成员客户编号
        ,CASE WHEN A.CUST_ID = C.GROUP_PARENT_CORP_ID THEN '1'  --核心成员
              ELSE '2'                                          --一般成员
         END                                    AS MBR_TYP                --成员类型  --modify by tangan at 20230114
        ,CASE WHEN A.CUST_ID = C.GROUP_PARENT_CORP_ID THEN 'Y'
              ELSE 'N'
         END                                    AS PAR_CO_FLG             --母公司标志  --modify by tangan at 20230114
        ,NVL(TRIM(A.SOCI_CRDT_CD),A.ORGNZ_CD)   AS MBR_USCC               --成员统一社会信用代码
        ,'800926' /*公司银行总部04*/            AS DEPT_LINE              --部门条线
        ,'集团客户'                             AS DATA_SRC               --数据来源
        ,A.GROUP_CORP_FLG                       AS GRP_CUST_FLG           --集团客户标识
        ,A.ORGNZ_CD                             AS SAIC_REGD_ID           --工商注册标识
  FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息  --mod by hulj20230113
  INNER JOIN ( --集团与成员关系  --modify by tangan at 20230114
        SELECT DISTINCT T.CUST_ID,T.GROUP_CUST_ID
        FROM
        (--集团成员
        SELECT A.CUST_ID,A.GROUP_CUST_ID
        FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A
        INNER JOIN ( --集团客户
              SELECT CUST_ID
              FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
              WHERE CRDT_CUST_TYPE_CD='5'
                AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            ) B
           ON A.GROUP_CUST_ID = B.CUST_ID
        WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          AND A.GROUP_CUST_ID <> A.CUST_ID --剔除集团自身 modify by tangan at 20221118
        /*UNION ALL --集团母公司
        SELECT GROUP_PARENT_CORP_ID AS CUST_ID,CUST_ID AS GROUP_CUST_ID
        FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
        WHERE CRDT_CUST_TYPE_CD='5'
        AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') */
        ) T
     ) B
    ON A.CUST_ID = B.CUST_ID
  LEFT JOIN ( --集团母公司  --modify by tangan at 20230114
        SELECT T1.GROUP_CUST_ID,T1.GROUP_PARENT_CORP_ID,T1.FLG,ROW_NUMBER() OVER(PARTITION BY T1.GROUP_CUST_ID ORDER BY T1.FLG) AS RN
        FROM (
          SELECT CUST_ID AS GROUP_CUST_ID,GROUP_PARENT_CORP_ID,'1' FLG
          FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
          WHERE CRDT_CUST_TYPE_CD='5'
          AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          AND TRIM(GROUP_PARENT_CORP_ID) IS NOT NULL
          UNION ALL
          SELECT GROUP_CUST_ID,GROUP_PARENT_CORP_ID,'2' FLG
          FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
          WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          AND CUST_ID = GROUP_PARENT_CORP_ID
        ) T1
     ) C
    ON B.GROUP_CUST_ID = C.GROUP_CUST_ID
   AND C.RN = 1
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, GRP_CUST_ID,MBR_NM,MBR_CUST_ID,COUNT(1)
      FROM M_CUST_CORP_GRPMBR_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, GRP_CUST_ID,MBR_NM,MBR_CUST_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CUST_CORP_GRPMBR_SUB;
/

