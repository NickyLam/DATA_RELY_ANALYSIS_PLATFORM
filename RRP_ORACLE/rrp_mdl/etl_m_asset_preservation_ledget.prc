CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ASSET_PRESERVATION_LEDGET(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_ASSET_PRESERVATION_LEDGET
  *  功能描述：资产保全台账
  *  创建日期：20230223
  *  开发人员：mw
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230223  于敬艺   对处置方式、五级分类等进行转码
                2    20230412   liuyu   添加 授信品种 字段
                3    20230602   liuyu   调整逻辑
                4   20230821    hulj    新增授信品种字段
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PROC_NAME VARCHAR2(40) := 'ETL_M_ASSET_PRESERVATION_LEDGET'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_ASSET_PRESERVATION_LEDGET T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_ASSET_PRESERVATION_LEDGET'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /*-- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'M_ASSET_PRESERVATION_LEDGET', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '总账会计科目信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_ASSET_PRESERVATION_LEDGET
    (DATA_DT                    --数据日期
    ,SERIALNO                   --流水号
    ,BRANCHBUSINESSDIVISION     --分行/事业部
    ,INPUTORGID                 --经办机构名称
    ,INPUTUSERID                --客户经理
    ,CUSTOMERID                 --客户编号
    ,DUEBILLID                  --借据号
    ,CUSTOMERNAME               --客户名称
    ,CUSTOMERTYPE               --客户类型
    ,INDUSTRY                   --行业
    ,ENTSCALE                   --企业规模
    ,ASSETTYPE                  --资产类型
    ,BEGINCREDITBALANCE         --年初授信余额折人民币
    ,BEGINRISKCLASSIFY          --年初风险分类
    ,FIRSTTIMEDESC              --第一次下调不良时间
    ,RISKISOLATIONRESULTS       --风险排查结果
    ,IRONRIDETIME               --列入铁骑名单时间
    ,HANDLERISKCLASSIFY         --处置时点风险分类
    ,HANDLETYPE                 --处置（含重组）方式
    ,TYPEASSETTRANSFER          --资产转让类型
    ,HANDLETIME                 --处置（含重组）时间
    ,HANDLEBALANCE              --处置金额
    ,REPAYMENTRESOURCE          --还款来源
    ,HANDLEINTERESTBALANCE      --处置欠息金额
    ,HANDLECHARGEDBALANCE       --处置罚息金额
    ,HANDLEREINTERESTEDBALANCE  --处置复息金额
    ,HANDLESUBSTITUTECUSHION    --处置代垫费用
    ,BEFORECLASSIFYRESULT       --变动前五级分类
    ,BEFOREBALANCE              --变动前余额
    ,AFTERCLASSIFYRESULT        --变动后五级分类
    ,CASHOFFDATE                --核销/抵债后收现日期（元）
    ,RECOVEROFFBALANCE          --核销/抵债后收回金额（元）
    ,NORMALRECOVERBALANCE       --调回正常后收回金额
    ,REMARK                     --备注
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,ETL_TIMESTAMP              --ETL处理时间戳
    ,SXPZ                       --授信品种 --ADD BY LIUYU 20230412
    )
  SELECT V_P_DATE                                      AS DATA_DT                    --数据日期
        ,T1.SERIALNO                                   AS SERIALNO                   --流水号
        ,T1.BRANCHBUSINESSDIVISION                     AS BRANCHBUSINESSDIVISION     --分行/事业部
        ,T1.INPUTORGID                                 AS INPUTORGID                 --经办机构名称
        ,T1.INPUTUSERID                                AS INPUTUSERID                --客户经理
        ,T1.CUSTOMERID                                 AS CUSTOMERID                 --客户编号
        ,T1.DUEBILLID                                  AS DUEBILLID                  --借据号
        ,T1.CUSTOMERNAME                               AS CUSTOMERNAME               --客户名称
        ,CASE WHEN T1.CUSTOMERTYPE = '1' THEN '个人客户'
              WHEN T1.CUSTOMERTYPE = '2' THEN '公司客户'
          END                                          AS CUSTOMERTYPE               --客户类型
        ,T1.INDUSTRY                                   AS INDUSTRY                   --行业
        ,CASE WHEN T1.ENTSCALE = '1' THEN '大型企业'
              WHEN T1.ENTSCALE = '2' THEN '中型企业'
              WHEN T1.ENTSCALE = '3' THEN '小型企业'
              WHEN T1.ENTSCALE = '4' THEN '微型企业'
              WHEN T1.ENTSCALE = '9' THEN '其他'
          END                                          AS ENTSCALE                   --企业规模
        ,CASE WHEN T1.ASSETTYPE = '1' THEN '不良贷款'
              WHEN T1.ASSETTYPE = '2' THEN '不良资产（非信贷）'
              WHEN T1.ASSETTYPE = '3' THEN '非不良问题贷款'
              WHEN T1.ASSETTYPE = '4' THEN '非不良问题资产（非信贷）'
              WHEN T1.ASSETTYPE = '5' THEN '已核销资产'
              WHEN T1.ASSETTYPE = '6' THEN '抵债资产'
          END                                          AS ASSETTYPE                  --资产类型
        ,T1.BEGINCREDITBALANCE                         AS BEGINCREDITBALANCE         --年初授信余额折人民币
        ,CASE WHEN T1.BEGINRISKCLASSIFY = '1' THEN '正常类'
              WHEN T1.BEGINRISKCLASSIFY = '2' THEN '关注类'
              WHEN T1.BEGINRISKCLASSIFY = '3' THEN '次级类'
              WHEN T1.BEGINRISKCLASSIFY = '4' THEN '可疑类'
              WHEN T1.BEGINRISKCLASSIFY = '5' THEN '损失类'
          END                                          AS BEGINRISKCLASSIFY          --年初风险分类
        ,T1.FIRSTTIMEDESC                              AS FIRSTTIMEDESC              --第一次下调不良时间
        ,CASE WHEN T1.RISKISOLATIONRESULTS = '1' THEN 'R1'
              WHEN T1.RISKISOLATIONRESULTS = '2' THEN 'R2'
          END                                          AS RISKISOLATIONRESULTS       --风险排查结果
        ,T1.IRONRIDETIME                               AS IRONRIDETIME               --列入铁骑名单时间
        ,CASE WHEN T1.HANDLERISKCLASSIFY = '1' THEN '正常类'
              WHEN T1.HANDLERISKCLASSIFY = '2' THEN '关注类'
              WHEN T1.HANDLERISKCLASSIFY = '3' THEN '次级类'
              WHEN T1.HANDLERISKCLASSIFY = '4' THEN '可疑类'
              WHEN T1.HANDLERISKCLASSIFY = '5' THEN '损失类'
          END                                          AS HANDLERISKCLASSIFY         --处置时点风险分类
        ,CASE WHEN T1.HANDLETYPE = '1' THEN '现金收回'
              WHEN T1.HANDLETYPE = '2' THEN '直接催收'
              WHEN T1.HANDLETYPE = '3' THEN '司法清收'
              WHEN T1.HANDLETYPE = '4' THEN '第三方代偿'
              WHEN T1.HANDLETYPE = '5' THEN '债务重组'
              WHEN T1.HANDLETYPE = '6' THEN '借新还旧'
              WHEN T1.HANDLETYPE = '7' THEN '展期'
              WHEN T1.HANDLETYPE = '8' THEN '全额核销'
              WHEN T1.HANDLETYPE = '9' THEN '差额核销'
              WHEN T1.HANDLETYPE = '10' THEN '资产转让'
              WHEN T1.HANDLETYPE = '11' THEN '以物抵债'
              WHEN T1.HANDLETYPE = '12' THEN '资产证券化'
              WHEN T1.HANDLETYPE = '13' THEN '债转股'
          END                                          AS HANDLETYPE                 --处置（含重组）方式
        ,CASE WHEN T1.TYPEASSETTRANSFER = '1' THEN '批量转让'
              WHEN T1.TYPEASSETTRANSFER = '2' THEN '单户转让'
          END                                          AS TYPEASSETTRANSFER          --资产转让类型
        ,T1.HANDLETIME                                 AS HANDLETIME                 --处置（含重组）时间
        ,T1.HANDLEBALANCE                              AS HANDLEBALANCE              --处置金额
        ,CASE WHEN T1.REPAYMENTRESOURCE = '1' THEN '借款人'
              WHEN T1.REPAYMENTRESOURCE = '2' THEN '保证人'
              WHEN T1.REPAYMENTRESOURCE = '3' THEN '第三方代偿'
              WHEN T1.REPAYMENTRESOURCE = '4' THEN '抵质押物'
              WHEN T1.REPAYMENTRESOURCE = '5' THEN '查封资产'
              WHEN T1.REPAYMENTRESOURCE = '6' THEN '转让款'
              WHEN T1.REPAYMENTRESOURCE = '7' THEN '其他'
          END                                          AS REPAYMENTRESOURCE          --还款来源
        ,T1.HANDLEINTERESTBALANCE                      AS HANDLEINTERESTBALANCE      --处置欠息金额
        ,T1.HANDLECHARGEDBALANCE                       AS HANDLECHARGEDBALANCE       --处置罚息金额
        ,T1.HANDLEREINTERESTEDBALANCE                  AS HANDLEREINTERESTEDBALANCE  --处置复息金额
        ,T1.HANDLESUBSTITUTECUSHION                    AS HANDLESUBSTITUTECUSHION    --处置代垫费用
        ,CASE WHEN T1.BEFORECLASSIFYRESULT = '1' THEN '正常类'
              WHEN T1.BEFORECLASSIFYRESULT = '2' THEN '关注类'
              WHEN T1.BEFORECLASSIFYRESULT = '3' THEN '次级类'
              WHEN T1.BEFORECLASSIFYRESULT = '4' THEN '可疑类'
              WHEN T1.BEFORECLASSIFYRESULT = '5' THEN '损失类'
          END                                          AS BEFORECLASSIFYRESULT       --变动前五级分类
        ,T1.BEFOREBALANCE                              AS BEFOREBALANCE              --变动前余额
        ,CASE WHEN T1.AFTERCLASSIFYRESULT = '1' THEN '正常类'
              WHEN T1.AFTERCLASSIFYRESULT = '2' THEN '关注类'
              WHEN T1.AFTERCLASSIFYRESULT = '3' THEN '次级类'
              WHEN T1.AFTERCLASSIFYRESULT = '4' THEN '可疑类'
              WHEN T1.AFTERCLASSIFYRESULT = '5' THEN '损失类'
          END                                          AS AFTERCLASSIFYRESULT        --变动后五级分类
        ,T1.CASHOFFDATE                                AS CASHOFFDATE                --核销/抵债后收现日期（元）
        ,T1.RECOVEROFFBALANCE                          AS RECOVEROFFBALANCE          --核销/抵债后收回金额（元）
        ,T1.NORMALRECOVERBALANCE                       AS NORMALRECOVERBALANCE       --调回正常后收回金额
        ,T1.REMARK                                     AS REMARK                     --备注
        ,T1.START_DT                                   AS START_DT                   --开始时间
        ,T1.END_DT                                     AS END_DT                     --结束时间
        ,T1.ID_MARK                                    AS ID_MARK                    --增删标志
        ,''                                            AS ETL_TIMESTAMP              --ETL处理时间戳
        --MOD BY LIUYU 删除使用数仓时间戳
        ,T1.BUSINESSTYPE                               AS SXPZ                       --授信品种 上游待投产后接入 ADD BU HULJ20230821
    FROM RRP_MDL.O_IOL_ICMS_ASSET_PRESERVATION_LEDGET T1
   WHERE T1.ID_MARK <> 'D' -- MOD BY LIUYU 20230602
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);

   -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_ASSET_PRESERVATION_LEDGET;
/

