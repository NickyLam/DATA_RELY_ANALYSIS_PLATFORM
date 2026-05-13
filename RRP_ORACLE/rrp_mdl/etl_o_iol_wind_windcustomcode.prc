CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_WIND_WINDCUSTOMCODE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_WIND_WINDCUSTOMCODE
  *  功能描述：Wind兼容代码
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_WINDCUSTOMCODE
  *  目标表： O_IOL_WIND_WINDCUSTOMCODE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_WIND_WINDCUSTOMCODE'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_WIND_WINDCUSTOMCODE T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_WIND_WINDCUSTOMCODE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-Wind兼容代码';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_WIND_WINDCUSTOMCODE
  (  OBJECT_ID			         --对象ID
    ,S_INFO_WINDCODE			   --Wind代码
    ,S_INFO_ASHARECODE			 --证券ID
    ,S_INFO_COMPCODE			   --公司ID
    ,S_INFO_SECURITIESTYPES	 --证券类型
    ,S_INFO_SECTYPENAME			 --类型名称
    ,S_INFO_COUNTRYNAME			 --国别
    ,S_INFO_COUNTRYCODE			 --国别编号
    ,S_INFO_EXCHMARKETNAME	 --交易所
    ,S_INFO_EXCHMARKET			 --交易所编号
    ,CRNCY_NAME			         --币种
    ,CRNCY_CODE			         --币种编号
    ,S_INFO_ISINCODE			   --ISIN代码
    ,S_INFO_CODE			       --交易代码
    ,S_INFO_NAME			       --证券中文简称
    ,EXCHMARKET			         --交易所
    ,SECURITY_STATUS			   --存续状态
    ,S_INFO_ORG_CODE			   --组织机构代码
    ,S_INFO_TYPECODE			   --分类代码
    ,S_INFO_MIN_PRICE_CHG_UNIT			--最小价格变动单位
    ,S_INFO_LOT_SIZE		    	--每手数量
    ,S_INFO_ENAME			        --证券英文简称
    ,OPDATE			              --未知
    ,OPMODE			              --未知
    ,START_DT			            --起始日期
    ,END_DT			              --截止日期
    ,ID_MARK			            --增删标志
    ,ETL_TIMESTAMP			      --etl处理时间
    )
    SELECT
     OBJECT_ID			         --对象ID
    ,S_INFO_WINDCODE			   --Wind代码
    ,S_INFO_ASHARECODE			 --证券ID
    ,S_INFO_COMPCODE			   --公司ID
    ,S_INFO_SECURITIESTYPES	 --证券类型
    ,S_INFO_SECTYPENAME			 --类型名称
    ,S_INFO_COUNTRYNAME			 --国别
    ,S_INFO_COUNTRYCODE			 --国别编号
    ,S_INFO_EXCHMARKETNAME	 --交易所
    ,S_INFO_EXCHMARKET			 --交易所编号
    ,CRNCY_NAME			         --币种
    ,CRNCY_CODE			         --币种编号
    ,S_INFO_ISINCODE			   --ISIN代码
    ,S_INFO_CODE			       --交易代码
    ,S_INFO_NAME			       --证券中文简称
    ,EXCHMARKET			         --交易所
    ,SECURITY_STATUS			   --存续状态
    ,S_INFO_ORG_CODE			   --组织机构代码
    ,S_INFO_TYPECODE			   --分类代码
    ,S_INFO_MIN_PRICE_CHG_UNIT			--最小价格变动单位
    ,S_INFO_LOT_SIZE		    	--每手数量
    ,S_INFO_ENAME			        --证券英文简称
    ,OPDATE			              --未知
    ,OPMODE			              --未知
    ,START_DT			            --起始日期
    ,END_DT			              --截止日期
    ,ID_MARK			            --增删标志
    ,ETL_TIMESTAMP			      --etl处理时间
    FROM IOL.V_WIND_WINDCUSTOMCODE  --视图-WIND兼容代码
   WHERE ID_MARK <> 'D' ;

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

  END ETL_O_IOL_WIND_WINDCUSTOMCODE;
/

