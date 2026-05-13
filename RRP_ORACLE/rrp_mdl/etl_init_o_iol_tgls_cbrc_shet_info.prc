CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_TGLS_CBRC_SHET_INFO (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_TGLS_CBRC_SHET_INFO
  *  功能描述：报表基本信息表
  *  创建日期：20221211
  *  开发人员：梅炜
  *  来源表： IOL.V_TGLS_CBRC_SHET_INFO
  *  目标表： O_IOL_TGLS_CBRC_SHET_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221211  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_TGLS_CBRC_SHET_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_TGLS_CBRC_SHET_INFO  ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_TGLS_CBRC_SHET_INFO ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户账户注册手机号历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_TGLS_CBRC_SHET_INFO
  (
      SUBSYS  --子系统编号
      ,SHETCD  --报表编码
      ,SHETNA  --报表名称
      ,REPTFQ  --报表统计频度
      ,REPTUT  --报表单位
      ,REPTFG  --上报标志
      ,BEGNDT  --启用日期
      ,OVERDT  --停用日期
      ,SHETMP  --报表大类
      ,SHETSP  --报表子类
      ,PROCNA  --报表数据集(冗余字段，统一设置参数，已迁移到CBRC_SHET_BRCH表)
      ,INPTFG  --报表生成方式
      ,TABTOR  --报表创建人
      ,REVWER  --报表评审人
      ,RESPER  --报表负责人
      ,REMARK  --备注
      ,RPFTCH  --报送口径(冗余字段，统一设置参数，已迁移到CBRC_SHET_BRCH表)
      ,SCHEID  --编排顺序号
      ,FTITLE  --报文标题
      ,STITLE  --报文子标题_X0013_
      ,CRCYCD  --币种(冗余字段，无意义)
      ,SHETSN  --报文英文名称
      ,CURENT  --是否实时报表
      ,STACID  --帐套ID
      ,ISBALA  --是否涉及手工调账（1是2否）
      ,ISUSED  --启用（1是2否）
      ,SHETTP  --报表类型（1固定报表2动态报表）
      ,START_DT  --开始时间
      ,END_DT  --结束时间
      ,ID_MARK  --增删标志
      ,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
      SUBSYS  --子系统编号
      ,SHETCD  --报表编码
      ,SHETNA  --报表名称
      ,REPTFQ  --报表统计频度
      ,REPTUT  --报表单位
      ,REPTFG  --上报标志
      ,BEGNDT  --启用日期
      ,OVERDT  --停用日期
      ,SHETMP  --报表大类
      ,SHETSP  --报表子类
      ,PROCNA  --报表数据集(冗余字段，统一设置参数，已迁移到CBRC_SHET_BRCH表)
      ,INPTFG  --报表生成方式
      ,TABTOR  --报表创建人
      ,REVWER  --报表评审人
      ,RESPER  --报表负责人
      ,REMARK  --备注
      ,RPFTCH  --报送口径(冗余字段，统一设置参数，已迁移到CBRC_SHET_BRCH表)
      ,SCHEID  --编排顺序号
      ,FTITLE  --报文标题
      ,STITLE  --报文子标题_X0013_
      ,CRCYCD  --币种(冗余字段，无意义)
      ,SHETSN  --报文英文名称
      ,CURENT  --是否实时报表
      ,STACID  --帐套ID
      ,ISBALA  --是否涉及手工调账（1是2否）
      ,ISUSED  --启用（1是2否）
      ,SHETTP  --报表类型（1固定报表2动态报表）
      ,START_DT  --开始时间
      ,END_DT  --结束时间
      ,ID_MARK  --增删标志
      ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IOL.V_TGLS_CBRC_SHET_INFO
      --视图-报表基本信息表
;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_TGLS_CBRC_SHET_INFO ;
/

