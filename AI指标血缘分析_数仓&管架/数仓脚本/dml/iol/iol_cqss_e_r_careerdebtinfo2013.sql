/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_careerdebtinfo2013
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
drop table ${iol_schema}.cqss_e_r_careerdebtinfo2013_ex purge;
alter table ${iol_schema}.cqss_e_r_careerdebtinfo2013 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_careerdebtinfo2013 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_careerdebtinfo2013_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_careerdebtinfo2013 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_careerdebtinfo2013_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,ccy_fnds -- 货币资金:EG08BJ01
    ,shrttm_ivs -- 短期投资:EG08BJ02
    ,fnc_shld_ret_lmt -- 财政应返还额度:EG08BJ03
    ,rcvb_bl -- 应收票据:EG08BJ04
    ,rcvb -- 应收账款:EG08BJ05
    ,prpy_accval -- 预付账款:EG08BJ06
    ,othr_rv -- 其他应收款:EG08BJ07
    ,ivnt -- 存货:EG08BJ08
    ,othr_lqud_ast -- 其他流动资产:EG08BJ09
    ,lqud_ast_tot -- 流动资产合计:EG08BJ10
    ,ltemivs -- 长期投资:EG08BJ11
    ,fix_ast -- 固定资产:EG08BJ12
    ,fix_ast_ori_prc -- 固定资产原价:EG08BJ13
    ,acm_dprcn -- 累计折旧:EG08BJ14
    ,ucpt -- 在建工程:EG08BJ15
    ,intgbl_ast -- 无形资产:EG08BJ16
    ,intgbl_ast_ori_prc -- 无形资产原价:EG08BJ17
    ,acm_amrz -- 累计摊销:EG08BJ18
    ,to_displ_ast -- 待处置资产损溢:EG08BJ19
    ,non_lqud_ast_tot -- 非流动资产合计:EG08BJ20
    ,ast_tot -- 资产总计:EG08BJ21
    ,shrttm_lnd -- 短期借款:EG08BJ22
    ,pbl_taxfee -- 应缴税费:EG08BJ23
    ,pbl_trsr_amt -- 应缴国库款:EG08BJ24
    ,pbl_fnc_spclacc_amt -- 应缴财政专户款:EG08BJ25
    ,empe_wage_expn -- 应付职工薪酬:EG08BJ26
    ,pbl_bl -- 应付票据:EG08BJ27
    ,pbl_accval -- 应付账款:EG08BJ28
    ,riav_accval -- 预收账款:EG08BJ29
    ,othr_pl -- 其他应付款:EG08BJ30
    ,othr_lqud_lby -- 其他流动负债:EG08BJ31
    ,lqud_lby_tot -- 流动负债合计:EG08BJ32
    ,longtrm_lnd -- 长期借款:EG08BJ33
    ,longtrm_pybl -- 长期应付款:EG08BJ34
    ,non_lqud_lby_tot -- 非流动负债合计:EG08BJ35
    ,lby_tot -- 负债合计:EG08BJ36
    ,crer_fnd -- 事业基金:EG08BJ37
    ,non_lqud_ast_fnd -- 非流动资产基金:EG08BJ38
    ,spclpps_fnd -- 专用基金:EG08BJ39
    ,fnc_alwc_crrov -- 财政补助结转:EG08BJ40
    ,fnc_alwc_srpls -- 财政补助结余:EG08BJ41
    ,non_fnc_alwc_crrov -- 非财政补助结转:EG08BJ42
    ,non_fnc_alwc_srpls -- 非财政补助结余:EG08BJ43
    ,crer_srpls -- 事业结余:EG08BJ44
    ,oprt_srpls -- 经营结余:EG08BJ45
    ,netast_tot -- 净资产合计:EG08BJ46
    ,lby_and_netast_tot -- 负债和净资产总计:EG08BJ47
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,ccy_fnds -- 货币资金:EG08BJ01
    ,shrttm_ivs -- 短期投资:EG08BJ02
    ,fnc_shld_ret_lmt -- 财政应返还额度:EG08BJ03
    ,rcvb_bl -- 应收票据:EG08BJ04
    ,rcvb -- 应收账款:EG08BJ05
    ,prpy_accval -- 预付账款:EG08BJ06
    ,othr_rv -- 其他应收款:EG08BJ07
    ,ivnt -- 存货:EG08BJ08
    ,othr_lqud_ast -- 其他流动资产:EG08BJ09
    ,lqud_ast_tot -- 流动资产合计:EG08BJ10
    ,ltemivs -- 长期投资:EG08BJ11
    ,fix_ast -- 固定资产:EG08BJ12
    ,fix_ast_ori_prc -- 固定资产原价:EG08BJ13
    ,acm_dprcn -- 累计折旧:EG08BJ14
    ,ucpt -- 在建工程:EG08BJ15
    ,intgbl_ast -- 无形资产:EG08BJ16
    ,intgbl_ast_ori_prc -- 无形资产原价:EG08BJ17
    ,acm_amrz -- 累计摊销:EG08BJ18
    ,to_displ_ast -- 待处置资产损溢:EG08BJ19
    ,non_lqud_ast_tot -- 非流动资产合计:EG08BJ20
    ,ast_tot -- 资产总计:EG08BJ21
    ,shrttm_lnd -- 短期借款:EG08BJ22
    ,pbl_taxfee -- 应缴税费:EG08BJ23
    ,pbl_trsr_amt -- 应缴国库款:EG08BJ24
    ,pbl_fnc_spclacc_amt -- 应缴财政专户款:EG08BJ25
    ,empe_wage_expn -- 应付职工薪酬:EG08BJ26
    ,pbl_bl -- 应付票据:EG08BJ27
    ,pbl_accval -- 应付账款:EG08BJ28
    ,riav_accval -- 预收账款:EG08BJ29
    ,othr_pl -- 其他应付款:EG08BJ30
    ,othr_lqud_lby -- 其他流动负债:EG08BJ31
    ,lqud_lby_tot -- 流动负债合计:EG08BJ32
    ,longtrm_lnd -- 长期借款:EG08BJ33
    ,longtrm_pybl -- 长期应付款:EG08BJ34
    ,non_lqud_lby_tot -- 非流动负债合计:EG08BJ35
    ,lby_tot -- 负债合计:EG08BJ36
    ,crer_fnd -- 事业基金:EG08BJ37
    ,non_lqud_ast_fnd -- 非流动资产基金:EG08BJ38
    ,spclpps_fnd -- 专用基金:EG08BJ39
    ,fnc_alwc_crrov -- 财政补助结转:EG08BJ40
    ,fnc_alwc_srpls -- 财政补助结余:EG08BJ41
    ,non_fnc_alwc_crrov -- 非财政补助结转:EG08BJ42
    ,non_fnc_alwc_srpls -- 非财政补助结余:EG08BJ43
    ,crer_srpls -- 事业结余:EG08BJ44
    ,oprt_srpls -- 经营结余:EG08BJ45
    ,netast_tot -- 净资产合计:EG08BJ46
    ,lby_and_netast_tot -- 负债和净资产总计:EG08BJ47
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_careerdebtinfo2013
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_careerdebtinfo2013 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_careerdebtinfo2013_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_careerdebtinfo2013 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_careerdebtinfo2013_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_careerdebtinfo2013',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);