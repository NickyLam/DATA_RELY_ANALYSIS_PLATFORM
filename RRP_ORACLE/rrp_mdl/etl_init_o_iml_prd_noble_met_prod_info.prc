CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_PRD_NOBLE_MET_PROD_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_PRD_NOBLE_MET_PROD_INFO
  *  功能描述：贵金属产品信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_PRD_NOBLE_MET_PROD_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_PRD_NOBLE_MET_PROD_INFO'; -- 程序名称
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
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_PRD_NOBLE_MET_PROD_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-贵金属产品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PRD_NOBLE_MET_PROD_INFO
  (      --ETL_DT  --数据日期
      PROD_ID  --产品编号
      ,LP_ID  --法人编号
      ,SER_NUM  --序列号
      ,MERCHD_ID  --商品编号
      ,STD_PROD_ID  --标准产品编号
      ,MERCHD_NAME  --商品名称
      ,MERCHD_BRAND  --商品品牌
      ,PROVI_NAME  --供应商名称
      ,MERCHD_TYPE_CD  --商品类型代码
      ,MERCHD_CLS_CD  --商品分类代码
      ,GOODS_ID  --货品编号
      ,PROD_FINE  --产品成色
      ,PROD_GOLD_CT  --产品含金量
      ,PROD_ARTM_CT  --产品含银量
      ,PROD_MATRL  --产品材质
      ,CRAFT  --工艺
      ,WEIGHT_CORP  --重量单位
      ,WEIGHT  --重量
      ,MEASURE  --尺寸
      ,PROD_PRICE  --产品单价
      ,PROD_QTTY  --产品数量
      ,PROD_COMM_FEE_RULE  --产品手续费规则
      ,SELL_LMT_QTTY  --销售限制数量
      ,PROD_STATUS_CD  --产品状态代码
      ,GROUNDING_TM  --上架时间
      ,UNDER_CARIGE_TM  --下架时间
      ,PROD_INFO_CREATE_TM  --产品信息创建时间
      ,PROD_INFO_UPDATE_TM  --产品信息更新时间
      ,ADDIT_DATA_1  --附加数据1
      ,ADDIT_DATA_2  --附加数据2
      ,START_DT  --开始日期
      ,END_DT  --结束日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    )
    SELECT

      --ETL_DT  --数据日期
      PROD_ID  --产品编号
      ,LP_ID  --法人编号
      ,SER_NUM  --序列号
      ,MERCHD_ID  --商品编号
      ,STD_PROD_ID  --标准产品编号
      ,MERCHD_NAME  --商品名称
      ,MERCHD_BRAND  --商品品牌
      ,PROVI_NAME  --供应商名称
      ,MERCHD_TYPE_CD  --商品类型代码
      ,MERCHD_CLS_CD  --商品分类代码
      ,GOODS_ID  --货品编号
      ,PROD_FINE  --产品成色
      ,PROD_GOLD_CT  --产品含金量
      ,PROD_ARTM_CT  --产品含银量
      ,PROD_MATRL  --产品材质
      ,CRAFT  --工艺
      ,WEIGHT_CORP  --重量单位
      ,WEIGHT  --重量
      ,MEASURE  --尺寸
      ,PROD_PRICE  --产品单价
      ,PROD_QTTY  --产品数量
      ,PROD_COMM_FEE_RULE  --产品手续费规则
      ,SELL_LMT_QTTY  --销售限制数量
      ,PROD_STATUS_CD  --产品状态代码
      ,GROUNDING_TM  --上架时间
      ,UNDER_CARIGE_TM  --下架时间
      ,PROD_INFO_CREATE_TM  --产品信息创建时间
      ,PROD_INFO_UPDATE_TM  --产品信息更新时间
      ,ADDIT_DATA_1  --附加数据1
      ,ADDIT_DATA_2  --附加数据2
      ,START_DT  --开始日期
      ,END_DT  --结束日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    FROM IML.V_PRD_NOBLE_MET_PROD_INFO;  --视图-贵金属产品信息
    --;

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

  END ETL_INIT_O_IML_PRD_NOBLE_MET_PROD_INFO;
/

