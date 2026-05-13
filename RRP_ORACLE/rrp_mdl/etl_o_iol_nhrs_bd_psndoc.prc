CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NHRS_BD_PSNDOC(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NHRS_BD_PSNDOC
  *  功能描述：人员基本信息
  *  创建日期：20251105
  *  开发人员：于敬艺
  *  来源表： IOL.V_NHRS_BD_PSNDOC
  *  目标表： O_IOL_NHRS_BD_PSNDOC
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251105  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NHRS_BD_PSNDOC'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NHRS_BD_PSNDOC';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-人员基本信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NHRS_BD_PSNDOC NOLOGGING
    (   ADDR
       ,BIRTHDATE
       ,CODE
       ,CREATIONTIME
       ,CREATOR
       ,DATAORIGINFLAG
       ,DEF1
       ,DEF10
       ,DEF11
       ,DEF12
       ,DEF13
       ,DEF14
       ,DEF15
       ,DEF16
       ,DEF17
       ,DEF18
       ,DEF19
       ,DEF2
       ,DEF20
       ,DEF3
       ,DEF4
       ,DEF5
       ,DEF6
       ,DEF7
       ,DEF8
       ,DEF9
       ,DR
       ,EMAIL
       ,ENABLESTATE
       ,HOMEPHONE
       ,ID
       ,IDTYPE
       ,ISSHOPASSIST
       ,JOINWORKDATE
       ,MNECODE
       ,MOBILE
       ,MODIFIEDTIME
       ,MODIFIER
       ,NAME
       ,NAME2
       ,NAME3
       ,NAME4
       ,NAME5
       ,NAME6
       ,OFFICEPHONE
       ,PK_GROUP
       ,PK_ORG
       ,PK_PSNDOC
       ,SEX
       ,TS
       ,USEDNAME
       ,BLOODTYPE
       ,CENSUSADDR
       ,CHARACTERRPR
       ,COUNTRY
       ,DIE_DATE
       ,DIE_REMARK
       ,EDU
       ,FAX
       ,FILEADDRESS
       ,HEALTH
       ,ISHISKEYPSN
       ,JOINPOLITYDATE
       ,MARITAL
       ,MARRIAGEDATE
       ,NATIONALITY
       ,NATIVEPLACE
       ,PENELAUTH
       ,PERMANRESIDE
       ,PHOTO
       ,PK_DEGREE
       ,PK_HRORG
       ,POLITY
       ,POSTALCODE
       ,PREVIEWPHOTO
       ,PROF
       ,RETIREDATE
       ,SECRET_EMAIL
       ,SHORTNAME
       ,TITLETECHPOST
       ,GLBDEF1
       ,GLBDEF2
       ,GLBDEF3
       ,GLBDEF4
       ,GLBDEF5
       ,GLBDEF6
       ,GLBDEF7
       ,GLBDEF8
       ,GLBDEF9
       ,GLBDEF10
       ,GLBDEF11
       ,GLBDEF12
       ,GLBDEF13
       ,GLBDEF14
       ,GLBDEF15
       ,GLBDEF16
       ,GLBDEF17
       ,GLBDEF18
       ,GLBDEF19
       ,GLBDEF20
       ,GLBDEF21
       ,GLBDEF22
       ,GLBDEF23
       ,GLBDEF24
       ,GLBDEF25
       ,GLBDEF26
       ,GLBDEF27
       ,GLBDEF28
       ,GLBDEF29
       ,GLBDEF30
       ,GLBDEF31
       ,GLBDEF32
       ,START_DT
       ,END_DT
       ,ID_MARK
       ,ETL_TIMESTAMP
     )
  SELECT /*+PARALLEL*/
        ADDR
       ,BIRTHDATE
       ,CODE
       ,CREATIONTIME
       ,CREATOR
       ,DATAORIGINFLAG
       ,DEF1
       ,DEF10
       ,DEF11
       ,DEF12
       ,DEF13
       ,DEF14
       ,DEF15
       ,DEF16
       ,DEF17
       ,DEF18
       ,DEF19
       ,DEF2
       ,DEF20
       ,DEF3
       ,DEF4
       ,DEF5
       ,DEF6
       ,DEF7
       ,DEF8
       ,DEF9
       ,DR
       ,EMAIL
       ,ENABLESTATE
       ,HOMEPHONE
       ,ID
       ,IDTYPE
       ,ISSHOPASSIST
       ,JOINWORKDATE
       ,MNECODE
       ,MOBILE
       ,MODIFIEDTIME
       ,MODIFIER
       ,NAME
       ,NAME2
       ,NAME3
       ,NAME4
       ,NAME5
       ,NAME6
       ,OFFICEPHONE
       ,PK_GROUP
       ,PK_ORG
       ,PK_PSNDOC
       ,SEX
       ,TS
       ,USEDNAME
       ,BLOODTYPE
       ,CENSUSADDR
       ,CHARACTERRPR
       ,COUNTRY
       ,DIE_DATE
       ,DIE_REMARK
       ,EDU
       ,FAX
       ,FILEADDRESS
       ,HEALTH
       ,ISHISKEYPSN
       ,JOINPOLITYDATE
       ,MARITAL
       ,MARRIAGEDATE
       ,NATIONALITY
       ,NATIVEPLACE
       ,PENELAUTH
       ,PERMANRESIDE
       ,PHOTO
       ,PK_DEGREE
       ,PK_HRORG
       ,POLITY
       ,POSTALCODE
       ,PREVIEWPHOTO
       ,PROF
       ,RETIREDATE
       ,SECRET_EMAIL
       ,SHORTNAME
       ,TITLETECHPOST
       ,GLBDEF1
       ,GLBDEF2
       ,GLBDEF3
       ,GLBDEF4
       ,GLBDEF5
       ,GLBDEF6
       ,GLBDEF7
       ,GLBDEF8
       ,GLBDEF9
       ,GLBDEF10
       ,GLBDEF11
       ,GLBDEF12
       ,GLBDEF13
       ,GLBDEF14
       ,GLBDEF15
       ,GLBDEF16
       ,GLBDEF17
       ,GLBDEF18
       ,GLBDEF19
       ,GLBDEF20
       ,GLBDEF21
       ,GLBDEF22
       ,GLBDEF23
       ,GLBDEF24
       ,GLBDEF25
       ,GLBDEF26
       ,GLBDEF27
       ,GLBDEF28
       ,GLBDEF29
       ,GLBDEF30
       ,GLBDEF31
       ,GLBDEF32
       ,START_DT
       ,END_DT
       ,ID_MARK
       ,ETL_TIMESTAMP
    FROM IOL.V_NHRS_BD_PSNDOC   --人员基本信息_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_O_IOL_NHRS_BD_PSNDOC;
/

