/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fin_instm_ext_info_ibmsf1
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
drop table ${iml_schema}.prd_fin_instm_ext_info_ibmsf1_tm purge;
alter table ${iml_schema}.prd_fin_instm_ext_info add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_fin_instm_ext_info modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_ext_info_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,ext_type_cd -- 扩展类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_multir -- 利率乘数
    ,amt -- 发生额
    ,contn_weight_type_cd -- 含权类型代码
    ,ex_type_cd -- 行权类型代码
    ,actl_ex_dt -- 实际行权日期
    ,ex_price -- 行权价格
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,updater_name -- 更新人名称
    ,update_tm -- 更新时间
    ,imp_way_id -- 导入方式编号
    ,imp_dt -- 导入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm_ext_info
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ibms_ttrd_instrument_extend-1
insert into ${iml_schema}.prd_fin_instm_ext_info_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,ext_type_cd -- 扩展类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,int_rat_multir -- 利率乘数
    ,amt -- 发生额
    ,contn_weight_type_cd -- 含权类型代码
    ,ex_type_cd -- 行权类型代码
    ,actl_ex_dt -- 实际行权日期
    ,ex_price -- 行权价格
    ,updater_name -- 起息日期
    ,update_tm -- 到期日期
    ,imp_way_id -- 更新人名称
    ,imp_dt -- 更新时间
    ,value_dt -- 导入方式编号
    ,exp_dt -- 导入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,P1.EXTEND_TYPE -- 扩展类型代码
    ,${iml_schema}.dateformat_min(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.dateformat_max(P1.END_DATE) -- 失效日期
    ,P1.RATE_MULTI -- 利率乘数
    ,P1.VOLUME -- 发生额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OE_TYPE END -- 含权类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.OE_OPTION_TYPE END -- 行权类型代码
    ,${iml_schema}.dateformat_min(P1.OE_FINISH_DATE) -- 实际行权日期
    ,P1.STRIKE_PRICE -- 行权价格
    ,P1.UPDATE_USER -- 起息日期
    ,${iml_schema}.TIMEFORMAT_MIN(P1.UPDATE_TIME) -- 到期日期
    ,P1.PIPE_ID -- 更新人名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 更新时间
    ,${iml_schema}.dateformat_min(P1.START_DATE) -- 导入方式编号
    ,${iml_schema}.dateformat_min(P1.MTR_DATE) -- 导入日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_instrument_extend' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_instrument_extend p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_INSTRUMENT_EXTEND'
        AND R1.SRC_FIELD_EN_NAME= 'OE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_EXT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CONTN_WEIGHT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OE_OPTION_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_INSTRUMENT_EXTEND'
        AND R2.SRC_FIELD_EN_NAME= 'OE_OPTION_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_EXT_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EX_TYPE_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.prd_fin_instm_ext_info truncate partition p_ibmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_fin_instm_ext_info exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_fin_instm_ext_info_ibmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fin_instm_ext_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_fin_instm_ext_info_ibmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fin_instm_ext_info', partname => 'p_ibmsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);