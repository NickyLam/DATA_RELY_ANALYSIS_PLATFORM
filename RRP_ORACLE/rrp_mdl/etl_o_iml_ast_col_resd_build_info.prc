CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AST_COL_RESD_BUILD_INFO(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AST_COL_RESD_BUILD_INFO
  *  功能描述：押品居住用房信息
  *  创建日期：20230825
  *  开发人员：HULIJUAN
  *  来源表： IML.V_AST_COL_RESD_BUILD_INFO
  *  目标表： O_IML_AST_COL_RESD_BUILD_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230825  HULIJUAN 首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AST_COL_RESD_BUILD_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AST_COL_RESD_BUILD_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品居住用房信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AST_COL_RESD_BUILD_INFO
    (ASSET_ID                --资产编号
    ,LP_ID                   --法人编号
    ,CURT_HOUSE_FLG          --现房标志
    ,PRESELL_LICS_ID         --预售许可证编号
    ,EXPECT_DLVY_TM          --预计交付时间
    ,EXPECT_REL_ESAT_WAT_TM  --预计取得不动产权证时间
    ,HOUSE_USED_FLG          --一手二手标志
    ,TWO_IN_ONE_FLG          --两证合一标志
    ,REL_ESAT_WAT_ID         --房产证号
    ,ALL_MTG_FLG             --全部抵押标志
    ,BS_CONT_ID              --买卖合同编号
    ,BUY_DT                  --购房日期
    ,BUY_AMT                 --购房金额
    ,SELL_RECD_FLG           --销售备案标志
    ,PURCH_ESTATE_FLG        --本次申购房产标志
    ,UNIQ_HOUSING_FLG        --唯一住房标志
    ,ARCH_AREA               --建筑面积
    ,USBL_AREA               --实用面积
    ,BUILD_YEAR              --建成年份
    ,PROP_TENOR              --产权期限
    ,BUILD_AGE               --楼龄
    ,APTMT_CD                --套型代码
    ,ORIENT_CD               --朝向代码
    ,PROP_SURP_TENOR         --产权剩余期限
    ,STRU_TYPE_CD            --结构类型代码
    ,STATUS_CD               --状态代码
    ,LOCAL_PROV_CD           --所在省代码
    ,LOCAL_CITY_CD           --所在市代码
    ,LOCAL_RG_CD             --所在区代码
    ,STREET_NAME             --街道名称
    ,STREET_ID               --街道编号
    ,DPLAT_ID                --门牌编号
    ,REL_ESAT_WAT_RGST_ADDR  --不动产权证登记地址
    ,ESTAT_NAME              --楼盘名称
    ,PLOT_RATIO              --容积率
    ,FLOOR_CNT               --楼层数
    ,TOT_FLOOR_CNT           --总楼层数
    ,LAND_USE_RIGHT_ID       --土地证号
    ,LAND_CHAR_CD            --土地所有权性质代码
    ,LAND_USE_AREA           --土地使用面积
    ,LAND_GET_WAY_CD         --土地取得方式代码
    ,LAND_USE_RIGHT_BEGIN_DT --土地使用权起始日期
    ,LAND_USE_RIGHT_EXP_DT   --土地使用权到期日期
    ,LAND_USE_RIGHT_YEARS    --土地使用权年限
    ,LAND_USAGE_CD           --土地用途代码
    ,OTHER_PROP_CERT_FLG     --已有他项权证标志
    ,OTHER_COMNT             --其他说明
    ,RENT_FLG                --出租标志
    ,TENTRY_NAME             --承租人名称
    ,RENT_BEGIN_DT           --出租起始日期
    ,RENT_EXP_DT             --出租到期日期
    ,RENT_SITU_COMNT         --出租情况说明
    ,CURR_CD                 --币种代码
    ,MONLY_MGMT_FEE          --每月管理费
    ,CREATE_DT               --创建日期
    ,UPDATE_DT               --更新日期
    ,ETL_DT                  --ETL处理日期
    ,ID_MARK                 --增删标志
    ,SRC_TABLE_NAME          --源表名称
    ,JOB_CD                  --任务编码
    ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT ASSET_ID                --资产编号
        ,LP_ID                   --法人编号
        ,CURT_HOUSE_FLG          --现房标志
        ,PRESELL_LICS_ID         --预售许可证编号
        ,EXPECT_DLVY_TM          --预计交付时间
        ,EXPECT_REL_ESAT_WAT_TM  --预计取得不动产权证时间
        ,HOUSE_USED_FLG          --一手二手标志
        ,TWO_IN_ONE_FLG          --两证合一标志
        ,REL_ESAT_WAT_ID         --房产证号
        ,ALL_MTG_FLG             --全部抵押标志
        ,BS_CONT_ID              --买卖合同编号
        ,BUY_DT                  --购房日期
        ,BUY_AMT                 --购房金额
        ,SELL_RECD_FLG           --销售备案标志
        ,PURCH_ESTATE_FLG        --本次申购房产标志
        ,UNIQ_HOUSING_FLG        --唯一住房标志
        ,ARCH_AREA               --建筑面积
        ,USBL_AREA               --实用面积
        ,BUILD_YEAR              --建成年份
        ,PROP_TENOR              --产权期限
        ,BUILD_AGE               --楼龄
        ,APTMT_CD                --套型代码
        ,ORIENT_CD               --朝向代码
        ,PROP_SURP_TENOR         --产权剩余期限
        ,STRU_TYPE_CD            --结构类型代码
        ,STATUS_CD               --状态代码
        ,LOCAL_PROV_CD           --所在省代码
        ,LOCAL_CITY_CD           --所在市代码
        ,LOCAL_RG_CD             --所在区代码
        ,STREET_NAME             --街道名称
        ,STREET_ID               --街道编号
        ,DPLAT_ID                --门牌编号
        ,REL_ESAT_WAT_RGST_ADDR  --不动产权证登记地址
        ,ESTAT_NAME              --楼盘名称
        ,PLOT_RATIO              --容积率
        ,FLOOR_CNT               --楼层数
        ,TOT_FLOOR_CNT           --总楼层数
        ,LAND_USE_RIGHT_ID       --土地证号
        ,LAND_CHAR_CD            --土地所有权性质代码
        ,LAND_USE_AREA           --土地使用面积
        ,LAND_GET_WAY_CD         --土地取得方式代码
        ,LAND_USE_RIGHT_BEGIN_DT --土地使用权起始日期
        ,LAND_USE_RIGHT_EXP_DT   --土地使用权到期日期
        ,LAND_USE_RIGHT_YEARS    --土地使用权年限
        ,LAND_USAGE_CD           --土地用途代码
        ,OTHER_PROP_CERT_FLG     --已有他项权证标志
        ,OTHER_COMNT             --其他说明
        ,RENT_FLG                --出租标志
        ,TENTRY_NAME             --承租人名称
        ,RENT_BEGIN_DT           --出租起始日期
        ,RENT_EXP_DT             --出租到期日期
        ,RENT_SITU_COMNT         --出租情况说明
        ,CURR_CD                 --币种代码
        ,MONLY_MGMT_FEE          --每月管理费
        ,CREATE_DT               --创建日期
        ,UPDATE_DT               --更新日期
        ,ETL_DT                  --ETL处理日期
        ,ID_MARK                 --增删标志
        ,SRC_TABLE_NAME          --源表名称
        ,JOB_CD                  --任务编码
        ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IML.V_AST_COL_RESD_BUILD_INFO  --视图-押品居住用房信息
   --WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AST_COL_RESD_BUILD_INFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_AST_COL_RESD_BUILD_INFO;
/

