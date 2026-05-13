CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_REPO_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_REPO_DTL
  *  功能描述：回购业务交易流水
  *  创建日期：20220616
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_TRA_REPO_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20220913  许晓滨    增加口径
  *             3    20220916  hulj      增加口径
  *             4    20221122  hulj      增加数据重复校验
  *             5    20231025  LYH       调整票据回购发生、结清逻辑
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);        --任务名称
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_REPO_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_REPO_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_EXN_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  ETL_PARTITION_ADD(I_P_DATE, 'M_TRA_REPO_DTL', '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_TRA_REPO_DTL'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  --20220913 XUXIAOBIN ADD
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--票据回购发生';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  --票据回购发生
  --UPDATE BY LYH 20231025，调整票据回购发生、结清逻辑
  SELECT V_P_DATE            AS DATA_DT           --数据日期
        ,A.LP_ID             AS LGL_REP_ID        --法人编号
        ,A.CONT_ID           AS SEQ_NO            --流水号
        ,A.BUS_ID            AS ACC_ID            --账户编号
        ,''                  AS TRA_TYP           --交易类型
        ,''                  AS OPEN_ACC_ORG_ID   --开户机构
        ,A.ACCT_INSTIT_ID    AS HDL_ORG_ID        --经办机构编号
        ,A.STL_AMT           AS TRA_AMT           --交易金额
        ,''                  AS OPP_ACC           --对方账号
        ,A.CNTPTY_NAME       AS OPP_ACC_NM        --对方户名
        ,A.CNTPTY_BANK_NO    AS OPP_PBC_NO        --对方行号
        ,''                  AS OPP_BANK_NM       --对方行名
        ,A.TRAN_DIR_CD       AS TRA_CHAN          --交易渠道
        ,A.CURR_CD           AS CUR               --币种
        ,''                  AS CASH_TRF_FLG      --现转标志
        ,''                  AS AGT_NM            --代办人姓名
        ,''                  AS AGT_CRDL_TYP      --代办人证件类型
        ,''                  AS AGT_CRDL_NO       --代办人证件号码
        ,''                  AS TRA_TLR_NO        --交易柜员号
        ,''                  AS GRANT_TLR_NO      --授权柜员号
        ,''                  AS ABSTR             --摘要
        ,''                  AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                  AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.STL_DT            AS TRA_TM            --交易时间
        ,''                  AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID           AS SUBJ_ID           --科目编号
        ,'1'                 AS OCCUR_SETL_TYP    --发生结清类型
        ,''                  AS DEPT_LINE         --部门条线
        ,'票据回购发生'      AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A   --票据转贴现信息表
   WHERE A.BUS_TYPE_CD IN ('BT02','BT03')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--票据回购结清';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  --票据回购结清
  --UPDATE BY LYH 20231025，调整票据回购发生、结清逻辑 
  SELECT V_P_DATE            AS DATA_DT            --数据日期
        ,A.LP_ID             AS LGL_REP_ID         --法人编号
        ,A.EXP_REPO_AGT_ID   AS SEQ_NO             --流水号
        ,A.BUS_ID            AS ACC_ID             --账户编号
        ,''                  AS TRA_TYP            --交易类型
        ,''                  AS OPEN_ACC_ORG_ID    --开户机构
        ,A.ACCT_INSTIT_ID    AS HDL_ORG_ID         --经办机构编号
        ,A.STL_AMT           AS TRA_AMT            --交易金额
        ,''                  AS OPP_ACC            --对方账号
        ,A.CNTPTY_NAME       AS OPP_ACC_NM         --对方户名
        ,A.CNTPTY_BANK_NO    AS OPP_PBC_NO         --对方行号
        ,''                  AS OPP_BANK_NM        --对方行名
        ,A.TRAN_DIR_CD       AS TRA_CHAN           --交易渠道
        ,A.CURR_CD           AS CUR                --币种
        ,''                  AS CASH_TRF_FLG       --现转标志
        ,''                  AS AGT_NM             --代办人姓名
        ,''                  AS AGT_CRDL_TYP       --代办人证件类型
        ,''                  AS AGT_CRDL_NO        --代办人证件号码
        ,''                  AS TRA_TLR_NO         --交易柜员号
        ,''                  AS GRANT_TLR_NO       --授权柜员号
        ,''                  AS ABSTR              --摘要
        ,''                  AS FLUSH_PATCH_FLG    --冲补抹标志
        ,''                  AS TRA_DR_CR_FLG      --交易借贷标志
        ,A.ACTL_REPO_DT      AS TRA_TM             --交易时间
        ,''                  AS AST_LBY_SIDE_FLG   --资产负债方标志
        ,A.SUBJ_ID           AS SUBJ_ID            --科目编号
        ,'0'                 AS OCCUR_SETL_TYP     --发生结清类型
        ,''                  AS DEPT_LINE          --部门条线
        ,'票据回购结清'      AS DATA_SRC           --数据来源
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A  --票据转贴现信息表
   WHERE A.BUS_TYPE_CD IN ('BT02','BT03')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.ACTL_REPO_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--资金债权回购发生';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  --资金债权回购发生
  SELECT V_P_DATE                      AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.TRAN_ID||'_1'               AS SEQ_NO            --流水号
        ,SUBSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,1,INSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,'.')-1) AS ACC_ID  --账户编号
        ,''                            AS TRA_TYP           --交易类型
        ,''                            AS OPEN_ACC_ORG_ID   --开户机构
        ,A.ENTRY_ORG_ID                AS HDL_ORG_ID        --经办机构编号
        ,A.TRAN_AMT                    AS TRA_AMT           --交易金额
        ,''                            AS OPP_ACC           --对方账号
        ,A.CNTPTY_NAME                 AS OPP_ACC_NM        --对方户名
        ,''                            AS OPP_PBC_NO        --对方行号
        ,''                            AS OPP_BANK_NM       --对方行名
        ,A.TRAN_DIR_CD                 AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,''                            AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,A.DEALER_ID                   AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.VALUE_DT                    AS TRA_TM            --交易时间
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'1'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'资金债权回购发生'            AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A --资金债券回购表
   WHERE A.VALUE_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--资金债权回购结清';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  --资金债权回购结清
  SELECT V_P_DATE                      AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.TRAN_ID||'_0'               AS SEQ_NO            --流水号
        ,SUBSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,1,INSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,'.')-1) AS ACC_ID  --账户编号
        ,''                            AS TRA_TYP           --交易类型
        ,''                            AS OPEN_ACC_ORG_ID   --开户机构
        ,A.ENTRY_ORG_ID                AS HDL_ORG_ID        --经办机构编号
        ,A.TRAN_AMT                    AS TRA_AMT           --交易金额
        ,''                            AS OPP_ACC           --对方账号
        ,A.CNTPTY_NAME                 AS OPP_ACC_NM        --对方户名
        ,''                            AS OPP_PBC_NO        --对方行号
        ,''                            AS OPP_BANK_NM       --对方行名
        ,A.TRAN_DIR_CD                 AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,''                            AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,A.DEALER_ID                   AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.EXP_DT                      AS TRA_TM            --交易时间
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'0'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'资金债权回购结清'            AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A --资金债券回购表
   WHERE A.EXP_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--外币回购发生';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  --外币回购发生
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.BUS_ID||'_1'                AS SEQ_NO            --流水号
        ,A.BAG_ID                      AS ACC_ID            --账户编号20221108 XUXIAOBIN MODIFY
        ,NULL                          AS TRA_TYP           --交易类型
        ,A.ENTRY_ORG_ID                AS ORG_ID            --机构编号
        ,A.ENTRY_ORG_ID                AS HDL_ORG_ID        --经办机构编号
        ,ABS(A.TRAN_AMT)               AS TRA_AMT           --交易金额
        ,NULL                          AS OPP_ACC           --对方账号
        ,A.CNTPTY_NAME                 AS OPP_ACC_NM        --对方户名
        ,NULL                          AS OPP_PBC_NO        --对方行号
        ,NULL                          AS OPP_BANK_NM       --对方行名
        ,A.TRAN_DIR_CD                 AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,''                            AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,''                            AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.VALUE_DT                    AS TRA_TM            --交易时间
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'1'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'外币回购发生'                AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
   WHERE A.INV_PORT_STATUS_CD IN ('A','C')--20230102 XUXIAOBIN ADD 来源陆炜迪提数脚本
     AND A.VALUE_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--还需要看其他模块的是否是每天取数再增加条件限制

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--外币回购结清';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.BUS_ID||'_0'                AS SEQ_NO            --流水号
        ,A.BAG_ID                      AS ACC_ID            --账户编号
        ,NULL                          AS TRA_TYP           --交易类型
        ,A.ENTRY_ORG_ID                AS ORG_ID            --机构编号
        ,A.ENTRY_ORG_ID                AS HDL_ORG_ID        --经办机构编号
        ,ABS(A.TRAN_AMT)               AS TRA_AMT           --交易金额
        ,NULL                          AS OPP_ACC           --对方账号
        ,A.CNTPTY_NAME                 AS OPP_ACC_NM        --对方户名
        ,NULL                          AS OPP_PBC_NO        --对方行号
        ,NULL                          AS OPP_BANK_NM       --对方行名
        ,A.TRAN_DIR_CD                 AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,''                            AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,''                            AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.EXP_DT                      AS TRA_TM            --交易时间
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'0'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'外币回购结清'                AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
   WHERE A.EXP_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.INV_PORT_STATUS_CD IN ('A','C')--20230102 XUXIAOBIN ADD 来源陆炜迪提数脚本
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--还需要看其他模块的是否是每天取数再增加条件限制

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--同业现金借贷质押式回购信息-发生';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.OBJ_ID||'_1'                AS SEQ_NO            --流水号
        ,A.BUS_ID                      AS ACC_ID            --账户编号
        ,NULL                          AS TRA_TYP           --交易类型
        ,A.BELONG_ORG_ID               AS ORG_ID            --机构编号
        ,A.BELONG_ORG_ID               AS HDL_ORG_ID        --经办机构编号
        ,A.TRAN_AMT                    AS TRA_AMT           --交易金额
        ,A.CNTPTY_ACCT_NUM             AS OPP_ACC           --对方账号
        ,A.CNTPTY_ACCT_NAME            AS OPP_ACC_NM        --对方户名
        ,A.CNTPTY_OPEN_BANK_NUM        AS OPP_PBC_NO        --对方行号
        ,A.CNTPTY_OPEN_BANK_NAME       AS OPP_BANK_NM       --对方行名
        ,NULL                          AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,NULL                          AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,''                            AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,B.VAL_DT                      AS TRA_TM            --交易时间
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'1'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'同业现金借贷回购'            AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息表
      ON D.SRC_PARTY_ID = A.CNTPTY_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT FIN_INSTM_ID,MARKET_TYPE_ID,ASSET_TYPE_ID,MAX(CALC_CLOSING_DT) EXP_DT,MIN(CALC_CLOSING_DT) VAL_DT
                 FROM RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL B
                WHERE B.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND B.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                GROUP BY FIN_INSTM_ID,MARKET_TYPE_ID,ASSET_TYPE_ID) B --同业券指令明细20230606 逻辑不确定，暂定
      ON B.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND B.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND B.ASSET_TYPE_ID = A.ASSET_TYPE_ID
   WHERE B.VAL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND (A.SUBJ_ID LIKE '111102%' --买入返售
          OR A.STD_PROD_ID LIKE '40103%') --卖出回购 --ADD BY 20240521
     AND ABS(A.CURRT_BAL) > 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--同业现金借贷质押式回购信息-结清';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SEQ_NO              --流水号
    ,ACC_ID              --账户编号
    ,TRA_TYP             --交易类型
    ,OPEN_ACC_ORG_ID     --开户机构
    ,HDL_ORG_ID          --经办机构编号
    ,TRA_AMT             --交易金额
    ,OPP_ACC             --对方账号
    ,OPP_ACC_NM          --对方户名
    ,OPP_PBC_NO          --对方行号
    ,OPP_BANK_NM         --对方行名
    ,TRA_CHAN            --交易渠道
    ,CUR                 --币种
    ,CASH_TRF_FLG        --现转标志
    ,AGT_NM              --代办人姓名
    ,AGT_CRDL_TYP        --代办人证件类型
    ,AGT_CRDL_NO         --代办人证件号码
    ,TRA_TLR_NO          --交易柜员号
    ,GRANT_TLR_NO        --授权柜员号
    ,ABSTR               --摘要
    ,FLUSH_PATCH_FLG     --冲补抹标志
    ,TRA_DR_CR_FLG       --交易借贷标志
    ,TRA_TM              --交易时间
    ,AST_LBY_SIDE_FLG    --资产负债方标志
    ,SUBJ_ID             --科目编号
    ,OCCUR_SETL_TYP      --发生结清类型
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT           --数据日期
        ,A.LP_ID                       AS LGL_REP_ID        --法人编号
        ,A.OBJ_ID||'_0'                AS SEQ_NO            --流水号
        ,A.BUS_ID                      AS ACC_ID            --账户编号
        ,NULL                          AS TRA_TYP           --交易类型
        ,A.BELONG_ORG_ID               AS ORG_ID            --机构编号
        ,A.BELONG_ORG_ID               AS HDL_ORG_ID        --经办机构编号
        ,A.TRAN_AMT                    AS TRA_AMT           --交易金额
        ,A.CNTPTY_ACCT_NUM             AS OPP_ACC           --对方账号
        ,A.CNTPTY_ACCT_NAME            AS OPP_ACC_NM        --对方户名
        ,A.CNTPTY_OPEN_BANK_NUM        AS OPP_PBC_NO        --对方行号
        ,A.CNTPTY_OPEN_BANK_NAME       AS OPP_BANK_NM       --对方行名
        ,NULL                          AS TRA_CHAN          --交易渠道
        ,A.CURR_CD                     AS CUR               --币种
        ,NULL                          AS CASH_TRF_FLG      --现转标志
        ,''                            AS AGT_NM            --代办人姓名
        ,''                            AS AGT_CRDL_TYP      --代办人证件类型
        ,''                            AS AGT_CRDL_NO       --代办人证件号码
        ,''                            AS TRA_TLR_NO        --交易柜员号
        ,''                            AS GRANT_TLR_NO      --授权柜员号
        ,''                            AS ABSTR             --摘要
        ,''                            AS FLUSH_PATCH_FLG   --冲补抹标志
        ,''                            AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.EXP_DT                      AS TRA_TM            --交易时间 --MOD BY 20240521
        ,''                            AS AST_LBY_SIDE_FLG  --资产负债方标志
        ,A.SUBJ_ID                     AS SUBJ_ID           --科目编号
        ,'0'                           AS OCCUR_SETL_TYP    --发生结清类型
        ,''                            AS DEPT_LINE         --部门条线
        ,'同业现金借贷质押式回购信息-结清' AS DATA_SRC      --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息表
      ON D.SRC_PARTY_ID = A.CNTPTY_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (A.SUBJ_ID LIKE '111102%' --买入返售
          OR A.STD_PROD_ID LIKE '40103%') --卖出回购  --ADD BY 20240521
     AND A.EXP_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 数据重复校验 --
    WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_REPO_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,SEQ_NO,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_M_TRA_REPO_DTL;
/

