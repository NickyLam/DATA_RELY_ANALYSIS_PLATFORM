/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_careerdebtinfo1997
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_e_r_careerdebtinfo1997_ex purge;
alter table ${iol_schema}.cqss_e_r_careerdebtinfo1997 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_careerdebtinfo1997 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_careerdebtinfo1997_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_careerdebtinfo1997 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_careerdebtinfo1997_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,cash -- 现金:EG07BJ01
    ,bk_dp -- 银行存款:EG07BJ02
    ,rcvb_bl -- 应收票据:EG07BJ03
    ,rcvb -- 应收账款:EG07BJ04
    ,prpy_accval -- 预付账款:EG07BJ05
    ,othr_rv -- 其他应收款:EG07BJ06
    ,mtrl -- 材料:EG07BJ07
    ,fsh_prdt -- 产成品:EG07BJ08
    ,ext_ivs -- 对外投资:EG07BJ09
    ,fix_ast -- 固定资产:EG07BJ10
    ,intgbl_ast -- 无形资产:EG07BJ11
    ,ast_tot -- 资产合计:EG07BJ12
    ,out_fee -- 拨出经费:EG07BJ13
    ,out_spclfnd -- 拨出专款:EG07BJ14
    ,spclfnd_expn -- 专款支出:EG07BJ15
    ,crer_expn -- 事业支出:EG07BJ16
    ,oprt_expn -- 经营支出:EG07BJ17
    ,cost_eps -- 成本费用:EG07BJ18
    ,sale_tax -- 销售税金:EG07BJ19
    ,tnov_supr_expn -- 上缴上级支出:EG07BJ20
    ,to_aflt_unit_alwc -- 对附属单位补助:EG07BJ21
    ,crrov_slfnc_nfrstr -- 结转自筹基建:EG07BJ22
    ,expn_tot -- 支出合计:EG07BJ23
    ,ast_dt_cgy_tot -- 资产部类总计:EG07BJ24
    ,dbt_fud -- 借记款项:EG07BJ25
    ,pbl_bl -- 应付票据:EG07BJ26
    ,pbl_accval -- 应付账款:EG07BJ27
    ,riav_accval -- 预收账款:EG07BJ28
    ,otpl -- 其他应付款:EG07BJ29
    ,pbl_bdgt_amt -- 应缴预算款:EG07BJ30
    ,pbl_fnc_spclacc_amt -- 应缴财政专户款:EG07BJ31
    ,acrtax -- 应交税金:EG07BJ32
    ,lby_tot -- 负债合计:EG07BJ33
    ,crer_fnd -- 事业基金:EG07BJ34
    ,com_fnd -- 一般基金:EG07BJ35
    ,ivs_fnd -- 投资基金:EG07BJ36
    ,fix_fnd -- 固定基金:EG07BJ37
    ,spclpps_fnd -- 专用基金:EG07BJ38
    ,crer_srpls -- 事业结余:EG07BJ39
    ,oprt_srpls -- 经营结余:EG07BJ40
    ,netast_tot -- 净资产合计:EG07BJ41
    ,fnc_alwc_incm -- 财政补助收入:EG07BJ42
    ,supr_alwc_incm -- 上级补助收入:EG07BJ43
    ,into_spclfnd -- 拨入专款:EG07BJ44
    ,crer_incm -- 事业收入:EG07BJ45
    ,oprt_incm -- 经营收入:EG07BJ46
    ,aflt_unit_pym -- 附属单位缴款:EG07BJ47
    ,othr_icm -- 其他收入:EG07BJ48
    ,incm_tot -- 收入合计:EG07BJ49
    ,lby_dt_cgy_tot -- 负债部类总计:EG07BJ50
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,cash -- 现金:EG07BJ01
    ,bk_dp -- 银行存款:EG07BJ02
    ,rcvb_bl -- 应收票据:EG07BJ03
    ,rcvb -- 应收账款:EG07BJ04
    ,prpy_accval -- 预付账款:EG07BJ05
    ,othr_rv -- 其他应收款:EG07BJ06
    ,mtrl -- 材料:EG07BJ07
    ,fsh_prdt -- 产成品:EG07BJ08
    ,ext_ivs -- 对外投资:EG07BJ09
    ,fix_ast -- 固定资产:EG07BJ10
    ,intgbl_ast -- 无形资产:EG07BJ11
    ,ast_tot -- 资产合计:EG07BJ12
    ,out_fee -- 拨出经费:EG07BJ13
    ,out_spclfnd -- 拨出专款:EG07BJ14
    ,spclfnd_expn -- 专款支出:EG07BJ15
    ,crer_expn -- 事业支出:EG07BJ16
    ,oprt_expn -- 经营支出:EG07BJ17
    ,cost_eps -- 成本费用:EG07BJ18
    ,sale_tax -- 销售税金:EG07BJ19
    ,tnov_supr_expn -- 上缴上级支出:EG07BJ20
    ,to_aflt_unit_alwc -- 对附属单位补助:EG07BJ21
    ,crrov_slfnc_nfrstr -- 结转自筹基建:EG07BJ22
    ,expn_tot -- 支出合计:EG07BJ23
    ,ast_dt_cgy_tot -- 资产部类总计:EG07BJ24
    ,dbt_fud -- 借记款项:EG07BJ25
    ,pbl_bl -- 应付票据:EG07BJ26
    ,pbl_accval -- 应付账款:EG07BJ27
    ,riav_accval -- 预收账款:EG07BJ28
    ,otpl -- 其他应付款:EG07BJ29
    ,pbl_bdgt_amt -- 应缴预算款:EG07BJ30
    ,pbl_fnc_spclacc_amt -- 应缴财政专户款:EG07BJ31
    ,acrtax -- 应交税金:EG07BJ32
    ,lby_tot -- 负债合计:EG07BJ33
    ,crer_fnd -- 事业基金:EG07BJ34
    ,com_fnd -- 一般基金:EG07BJ35
    ,ivs_fnd -- 投资基金:EG07BJ36
    ,fix_fnd -- 固定基金:EG07BJ37
    ,spclpps_fnd -- 专用基金:EG07BJ38
    ,crer_srpls -- 事业结余:EG07BJ39
    ,oprt_srpls -- 经营结余:EG07BJ40
    ,netast_tot -- 净资产合计:EG07BJ41
    ,fnc_alwc_incm -- 财政补助收入:EG07BJ42
    ,supr_alwc_incm -- 上级补助收入:EG07BJ43
    ,into_spclfnd -- 拨入专款:EG07BJ44
    ,crer_incm -- 事业收入:EG07BJ45
    ,oprt_incm -- 经营收入:EG07BJ46
    ,aflt_unit_pym -- 附属单位缴款:EG07BJ47
    ,othr_icm -- 其他收入:EG07BJ48
    ,incm_tot -- 收入合计:EG07BJ49
    ,lby_dt_cgy_tot -- 负债部类总计:EG07BJ50
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_careerdebtinfo1997
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_careerdebtinfo1997 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_careerdebtinfo1997_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_careerdebtinfo1997 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_careerdebtinfo1997_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_careerdebtinfo1997',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);