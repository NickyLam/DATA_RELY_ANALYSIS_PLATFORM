/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_inpwn_vch_pledge_type_repo_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_inpwn_vch_pledge_type_repo_ibmsf1_tm purge;
alter table ${iml_schema}.prd_inpwn_vch_pledge_type_repo add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_inpwn_vch_pledge_type_repo modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_inpwn_vch_pledge_type_repo_ibmsf1_tm
compress ${option_switch} for query high
as
select
    lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,inpwn_vch_fin_instm_id -- 质押券金融工具编号
    ,inpwn_vch_asset_type_id -- 质押券资产类型编号
    ,inpwn_vch_market_type_id -- 质押券市场类型编号
    ,inpwn_cert_face_lmt -- 质押券面额
    ,discnt_rat -- 折价率
    ,discnt_amt -- 折价金额
    ,int_ext_tran_flg -- 内外部交易标志
    ,inpwn_vch_guar_type_cd -- 质押券担保类型代码
    ,cbond_evltion -- 中债估值
    ,bal_qtty_chg -- 余额数量变动
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,tran_seq_num -- 交易单序号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_inpwn_vch_pledge_type_repo
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- prd_inpwn_vch_pledge_type_repo-1
insert into ${iml_schema}.prd_inpwn_vch_pledge_type_repo_ibmsf1_tm(
    lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,inpwn_vch_fin_instm_id -- 质押券金融工具编号
    ,inpwn_vch_asset_type_id -- 质押券资产类型编号
    ,inpwn_vch_market_type_id -- 质押券市场类型编号
    ,inpwn_cert_face_lmt -- 质押券面额
    ,discnt_rat -- 折价率
    ,discnt_amt -- 折价金额
    ,int_ext_tran_flg -- 内外部交易标志
    ,inpwn_vch_guar_type_cd -- 质押券担保类型代码
    ,cbond_evltion -- 中债估值
    ,bal_qtty_chg -- 余额数量变动
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,ext_secu_acct_id -- 外部证券账户编号
    ,tran_seq_num -- 交易单序号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.P_I_CODE -- 质押券金融工具编号
    ,P1.P_M_TYPE -- 质押券资产类型编号
    ,P1.P_A_TYPE -- 质押券市场类型编号
    ,P1.AMOUNT -- 质押券面额
    ,P1.DISCOUNT -- 折价率
    ,P1.DISAMOUNT -- 折价金额
    ,NVL(TRIM(P1.PARTYTYPE),'-') -- 内外部交易标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RESERTYPE END -- 质押券担保类型代码
    ,P1.EVALFULLPRICE -- 中债估值
    ,P1.VOLUME -- 余额数量变动
    ,P1.SECU_ACCT_ID -- 内部证券账户编号
    ,P1.EXT_SECU_ACCT_ID -- 外部证券账户编号
    ,P1.SYSORDID -- 交易单序号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_pledgebond' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_pledgebond p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RESERTYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_PLEDGEBOND'
        AND R1.SRC_FIELD_EN_NAME= 'RESERTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_INPWN_VCH_PLEDGE_TYPE_REPO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INPWN_VCH_GUAR_TYPE_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.prd_inpwn_vch_pledge_type_repo truncate partition p_ibmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_inpwn_vch_pledge_type_repo exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_inpwn_vch_pledge_type_repo_ibmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_inpwn_vch_pledge_type_repo to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_inpwn_vch_pledge_type_repo_ibmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_inpwn_vch_pledge_type_repo', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);