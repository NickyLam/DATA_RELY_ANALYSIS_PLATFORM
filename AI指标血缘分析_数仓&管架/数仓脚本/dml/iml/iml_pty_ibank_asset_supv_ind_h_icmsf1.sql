/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_ibank_asset_supv_ind_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_ibank_asset_supv_ind_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_ibank_asset_supv_ind_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op purge;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_asset_supv_ind_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_ibank_asset_supv_ind_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_ibank_asset_supv_ind_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_jkzb-
insert into ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm(
    flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 流水号
    , '9999' -- 法人编号
    ,P1.CUSTOMERID -- 当事人编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.BELONGYEAR -- 指标年度
    ,P1.ZLCHANNEL -- 信息来源描述
    ,P1.ZCSUM -- 总资产
    ,P1.GAINZB -- 净资产
    ,P1.ZCGLSCOPE -- 资产管理规模
    ,P1.CKSCOPE -- 存款规模
    ,P1.DKSCOPE -- 贷款规模
    ,P1.LDXSCALE1 -- 人民币流动性比例
    ,P1.LDXSCALE2 -- 外币流动性比例
    ,P1.LDXSCALE3 -- 本外币流动性比例
    ,P1.CDSCALE1 -- 人民币存贷比例
    ,P1.CDSCALE2 -- 外币存贷比例
    ,P1.CDSCALE3 -- 本外币存贷比例
    ,P1.STOCKB -- 股本
    ,P1.STOCKDQY -- 股东权益
    ,P1.BUSINESSJSR -- 营业净收入
    ,P1.JINCOME -- 净利润
    ,P1.BADSCALE -- 不良资产率
    ,P1.XTSRSCALE -- 信托业务收入占比
    ,P1.XTBCSCALE -- 信托报酬率
    ,P1.CBSRSCALE -- 成本收入比
    ,P1.ZZCSCALE -- 资产利润率
    ,P1.ZBSYSCALE -- 资本利润率
    ,P1.GZCREDITSCALE -- 关注贷款比例
    ,P1.YQCREDITSCALE -- 逾期贷款比例
    ,P1.BADCREDITSCALE -- 不良贷款比例
    ,P1.ZBCZSCALE -- 资本充足率
    ,P1.CFLLSCALE -- 偿付能力充足率
    ,P1.FXFGSCALE -- 风险覆盖率
    ,P1.JWDZJSCALE -- 净稳定资金率
    ,P1.BADZLSCALE -- 不良融资租赁资产率
    ,P1.BADDKYE -- 不良贷款余额
    ,P1.GZLDKYE -- 关注类贷款余额
    ,P1.ZBJYE -- 准备金余额
    ,P1.DBSCALE -- 担保比例
    ,P1.DITZSCALE -- 短期投资比例
    ,P1.CQTZSCALE -- 长期投资比例
    ,P1.TYCRSCALE -- 同业拆入比例
    ,P1.BDSCALE -- 拨备覆盖率
    ,P1.INPUTUSER -- 登记柜员编号
    ,P1.INPUTORG -- 登记机构编号
    ,P1.REGISTERCOUNTRYCODE -- 注册国家代码
    ,P1.COUNTRYRATING -- 所在国家评级
    ,P1.COUNTRYCAPSTANDARD -- 所在国家或地区监管部门的最低资本监管要求
    ,P1.COUNTRYADDONCAPITAL -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,P1.COREYJSCALE -- 核心一级资本充足率
    ,P1.YJZBSCALE -- 一级资本充足率
    ,P1.ZBCZSCALE -- 资本充足率
    ,P1.LEVERAGERATE -- 杠杆率
    ,P1.AUDITCOMMNENT -- 外部审计意见
    ,decode(trim(P1.RISKALERT),'Y','1','N','0','','-',trim(P1.RISKALERT)) -- 尽职调查发现存在重大风险标志
    ,P1.UPDATETIME -- 更新时间
    ,P1.INPUTTIME -- 首次创建时间
    ,P1.BADRZZLSCALE -- 拨备覆盖不良融资租赁资产率
    ,P1.BCREDITPYDSCALE -- 不良贷款与预期贷款偏离度
    ,P1.ZQJZBSCALE -- 持有一种权益类证券的成本与净资本比例
    ,P1.ZQSZSCALE -- 持有一种权益类证券市值与其总市值的比例
    ,nvl(to_number(regexp_replace(P1.DKZLZCGM,'[^0-9.]','')) ,0) -- 贷款/融资租赁资产规模
    ,P1.DKSSSCALE -- 贷款损失准备充足率
    ,P1.JTKFSCALE -- 集团客户关联度
    ,P1.DYJTGLSCALE -- 单一客户关联度
    ,P1.DYJTJZSCALE -- 单一客户集中度
    ,nvl(trim(P1.DYGDJZD),'0') -- 单一股东及其关联方授信集中度
    ,P1.DYJTSXSCALE -- 单一集团客户授信集中度
    ,P1.DYKHJZBSCALE -- 对单一客户融券业务规模与净资本比例
    ,P1.DYKHRZSCALE -- 对单一客户融资业务规模与净资本比例
    ,P1.FXTZZBSCALE -- 风险调整资本回报率
    ,P1.JSDGPSCALE -- 接受单只担保股票市值与该股票总市值比例
    ,P1.JWDSCALE -- 净稳定资金比例
    ,P1.LJCKSCALE -- 累计外汇敞口头寸占资本净额比例
    ,P1.LDFGSCALE -- 流动性覆盖率
    ,P1.LDPPSCALE -- 流动性匹配率
    ,P1.MRFSASSETS -- 买入返售金融资产
    ,P1.PJDLSCALE -- 平均代理证券业务净收入
    ,P1.RJPROFIT -- 人均利润
    ,P1.YSKINVEST -- 应收款项类投资金额
    ,P1.YZLDSCALE -- 优质流动性资产充足率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_jkzb' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_jkzb p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm 
  	                                group by 
  	                                        flow_num
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.ind_year, o.ind_year) as ind_year -- 指标年度
    ,nvl(n.info_src_descb, o.info_src_descb) as info_src_descb -- 信息来源描述
    ,nvl(n.tot_asset, o.tot_asset) as tot_asset -- 总资产
    ,nvl(n.net_asset, o.net_asset) as net_asset -- 净资产
    ,nvl(n.asset_mgmt_size, o.asset_mgmt_size) as asset_mgmt_size -- 资产管理规模
    ,nvl(n.dep_size, o.dep_size) as dep_size -- 存款规模
    ,nvl(n.loan_size, o.loan_size) as loan_size -- 贷款规模
    ,nvl(n.cny_liqd_ratio, o.cny_liqd_ratio) as cny_liqd_ratio -- 人民币流动性比例
    ,nvl(n.fcurr_liqd_ratio, o.fcurr_liqd_ratio) as fcurr_liqd_ratio -- 外币流动性比例
    ,nvl(n.lf_curr_liqd_ratio, o.lf_curr_liqd_ratio) as lf_curr_liqd_ratio -- 本外币流动性比例
    ,nvl(n.cny_dep_lon_ratio, o.cny_dep_lon_ratio) as cny_dep_lon_ratio -- 人民币存贷比例
    ,nvl(n.fcurr_dep_lon_ratio, o.fcurr_dep_lon_ratio) as fcurr_dep_lon_ratio -- 外币存贷比例
    ,nvl(n.lf_curr_dep_lon_ratio, o.lf_curr_dep_lon_ratio) as lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,nvl(n.cap_stock, o.cap_stock) as cap_stock -- 股本
    ,nvl(n.shard_eqty, o.shard_eqty) as shard_eqty -- 股东权益
    ,nvl(n.bus_net_inco, o.bus_net_inco) as bus_net_inco -- 营业净收入
    ,nvl(n.net_margin, o.net_margin) as net_margin -- 净利润
    ,nvl(n.non_asset_rat, o.non_asset_rat) as non_asset_rat -- 不良资产率
    ,nvl(n.trust_bus_inco_pct, o.trust_bus_inco_pct) as trust_bus_inco_pct -- 信托业务收入占比
    ,nvl(n.trust_reward_rat, o.trust_reward_rat) as trust_reward_rat -- 信托报酬率
    ,nvl(n.cost_inco_ratio, o.cost_inco_ratio) as cost_inco_ratio -- 成本收入比
    ,nvl(n.asset_prft_rat, o.asset_prft_rat) as asset_prft_rat -- 资产利润率
    ,nvl(n.cap_prft_rat, o.cap_prft_rat) as cap_prft_rat -- 资本利润率
    ,nvl(n.concern_loan_ratio, o.concern_loan_ratio) as concern_loan_ratio -- 关注贷款比例
    ,nvl(n.ovdue_loan_ratio, o.ovdue_loan_ratio) as ovdue_loan_ratio -- 逾期贷款比例
    ,nvl(n.npl_ratio, o.npl_ratio) as npl_ratio -- 不良贷款比例
    ,nvl(n.cap_adquy_ratio, o.cap_adquy_ratio) as cap_adquy_ratio -- 资本充足率
    ,nvl(n.pay_back_adquy_ratio, o.pay_back_adquy_ratio) as pay_back_adquy_ratio -- 偿付能力充足率
    ,nvl(n.risk_cr, o.risk_cr) as risk_cr -- 风险覆盖率
    ,nvl(n.net_stab_fund_ratio, o.net_stab_fund_ratio) as net_stab_fund_ratio -- 净稳定资金率
    ,nvl(n.non_fin_rent_asset_rat, o.non_fin_rent_asset_rat) as non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,nvl(n.npl_bal, o.npl_bal) as npl_bal -- 不良贷款余额
    ,nvl(n.conce_loan_bal, o.conce_loan_bal) as conce_loan_bal -- 关注类贷款余额
    ,nvl(n.resv_bal, o.resv_bal) as resv_bal -- 准备金余额
    ,nvl(n.guar_ratio, o.guar_ratio) as guar_ratio -- 担保比例
    ,nvl(n.sh_term_invest_ratio, o.sh_term_invest_ratio) as sh_term_invest_ratio -- 短期投资比例
    ,nvl(n.lonterm_invest_ratio, o.lonterm_invest_ratio) as lonterm_invest_ratio -- 长期投资比例
    ,nvl(n.ibank_borrow_ratio, o.ibank_borrow_ratio) as ibank_borrow_ratio -- 同业拆入比例
    ,nvl(n.prov_covr, o.prov_covr) as prov_covr -- 拨备覆盖率
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_cty_cd, o.rgst_cty_cd) as rgst_cty_cd -- 注册国家代码
    ,nvl(n.local_cty_rating, o.local_cty_rating) as local_cty_rating -- 所在国家评级
    ,nvl(n.countrycapstandard, o.countrycapstandard) as countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,nvl(n.countryaddoncapital, o.countryaddoncapital) as countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,nvl(n.coretieronerate, o.coretieronerate) as coretieronerate -- 核心一级资本充足率
    ,nvl(n.tieronerate, o.tieronerate) as tieronerate -- 一级资本充足率
    ,nvl(n.capitaladeratio, o.capitaladeratio) as capitaladeratio -- 资本充足率
    ,nvl(n.lever_rat, o.lever_rat) as lever_rat -- 杠杆率
    ,nvl(n.ext_audit_opinion, o.ext_audit_opinion) as ext_audit_opinion -- 外部审计意见
    ,nvl(n.major_risk_flg, o.major_risk_flg) as major_risk_flg -- 尽职调查发现存在重大风险标志
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.fir_create_time, o.fir_create_time) as fir_create_time -- 首次创建时间
    ,nvl(n.badrzzl_scale, o.badrzzl_scale) as badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,nvl(n.npl_and_expe_loan_devit_degree, o.npl_and_expe_loan_devit_degree) as npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,nvl(n.zqjzb_scale, o.zqjzb_scale) as zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,nvl(n.zqsz_scale, o.zqsz_scale) as zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,nvl(n.loan_fin_rent_asset_size, o.loan_fin_rent_asset_size) as loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,nvl(n.loan_loss_prep_adquy_ratio, o.loan_loss_prep_adquy_ratio) as loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,nvl(n.group_cust_rela_degree, o.group_cust_rela_degree) as group_cust_rela_degree -- 集团客户关联度
    ,nvl(n.single_cust_rela_degree, o.single_cust_rela_degree) as single_cust_rela_degree -- 单一客户关联度
    ,nvl(n.single_cust_centr_degree, o.single_cust_centr_degree) as single_cust_centr_degree -- 单一客户集中度
    ,nvl(n.dyshard_prt_crdt_centr_degree, o.dyshard_prt_crdt_centr_degree) as dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,nvl(n.dy_group_cust_crdt_cendegree, o.dy_group_cust_crdt_cendegree) as dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,nvl(n.dykhjzb_scale, o.dykhjzb_scale) as dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,nvl(n.dykhrz_scale, o.dykhrz_scale) as dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,nvl(n.risk_adj_cap_rtn_rat, o.risk_adj_cap_rtn_rat) as risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,nvl(n.JSDGP_SCALE, o.JSDGP_SCALE) as JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,nvl(n.net_set_cap_ratio, o.net_set_cap_ratio) as net_set_cap_ratio -- 净稳定资金比例
    ,nvl(n.ljck_scale, o.ljck_scale) as ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,nvl(n.lcr, o.lcr) as lcr -- 流动性覆盖率
    ,nvl(n.liqd_match_rat, o.liqd_match_rat) as liqd_match_rat -- 流动性匹配率
    ,nvl(n.buy_rtn_sell_fin_asset, o.buy_rtn_sell_fin_asset) as buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,nvl(n.pjdl_scale, o.pjdl_scale) as pjdl_scale -- 平均代理证券业务净收入
    ,nvl(n.per_capita_margin, o.per_capita_margin) as per_capita_margin -- 人均利润
    ,nvl(n.accts_recvbl_class_invest_amt, o.accts_recvbl_class_invest_amt) as accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,nvl(n.excl_liqd_asset_adquy_ratio, o.excl_liqd_asset_adquy_ratio) as excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
    ,case when
            n.flow_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.flow_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.flow_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
where (
        o.flow_num is null
        and o.lp_id is null
    )
    or (
        n.flow_num is null
        and n.lp_id is null
    )
    or (
        o.party_id <> n.party_id
        or o.cust_id <> n.cust_id
        or o.ind_year <> n.ind_year
        or o.info_src_descb <> n.info_src_descb
        or o.tot_asset <> n.tot_asset
        or o.net_asset <> n.net_asset
        or o.asset_mgmt_size <> n.asset_mgmt_size
        or o.dep_size <> n.dep_size
        or o.loan_size <> n.loan_size
        or o.cny_liqd_ratio <> n.cny_liqd_ratio
        or o.fcurr_liqd_ratio <> n.fcurr_liqd_ratio
        or o.lf_curr_liqd_ratio <> n.lf_curr_liqd_ratio
        or o.cny_dep_lon_ratio <> n.cny_dep_lon_ratio
        or o.fcurr_dep_lon_ratio <> n.fcurr_dep_lon_ratio
        or o.lf_curr_dep_lon_ratio <> n.lf_curr_dep_lon_ratio
        or o.cap_stock <> n.cap_stock
        or o.shard_eqty <> n.shard_eqty
        or o.bus_net_inco <> n.bus_net_inco
        or o.net_margin <> n.net_margin
        or o.non_asset_rat <> n.non_asset_rat
        or o.trust_bus_inco_pct <> n.trust_bus_inco_pct
        or o.trust_reward_rat <> n.trust_reward_rat
        or o.cost_inco_ratio <> n.cost_inco_ratio
        or o.asset_prft_rat <> n.asset_prft_rat
        or o.cap_prft_rat <> n.cap_prft_rat
        or o.concern_loan_ratio <> n.concern_loan_ratio
        or o.ovdue_loan_ratio <> n.ovdue_loan_ratio
        or o.npl_ratio <> n.npl_ratio
        or o.cap_adquy_ratio <> n.cap_adquy_ratio
        or o.pay_back_adquy_ratio <> n.pay_back_adquy_ratio
        or o.risk_cr <> n.risk_cr
        or o.net_stab_fund_ratio <> n.net_stab_fund_ratio
        or o.non_fin_rent_asset_rat <> n.non_fin_rent_asset_rat
        or o.npl_bal <> n.npl_bal
        or o.conce_loan_bal <> n.conce_loan_bal
        or o.resv_bal <> n.resv_bal
        or o.guar_ratio <> n.guar_ratio
        or o.sh_term_invest_ratio <> n.sh_term_invest_ratio
        or o.lonterm_invest_ratio <> n.lonterm_invest_ratio
        or o.ibank_borrow_ratio <> n.ibank_borrow_ratio
        or o.prov_covr <> n.prov_covr
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_cty_cd <> n.rgst_cty_cd
        or o.local_cty_rating <> n.local_cty_rating
        or o.countrycapstandard <> n.countrycapstandard
        or o.countryaddoncapital <> n.countryaddoncapital
        or o.coretieronerate <> n.coretieronerate
        or o.tieronerate <> n.tieronerate
        or o.capitaladeratio <> n.capitaladeratio
        or o.lever_rat <> n.lever_rat
        or o.ext_audit_opinion <> n.ext_audit_opinion
        or o.major_risk_flg <> n.major_risk_flg
        or o.update_tm <> n.update_tm
        or o.fir_create_time <> n.fir_create_time
        or o.badrzzl_scale <> n.badrzzl_scale
        or o.npl_and_expe_loan_devit_degree <> n.npl_and_expe_loan_devit_degree
        or o.zqjzb_scale <> n.zqjzb_scale
        or o.zqsz_scale <> n.zqsz_scale
        or o.loan_fin_rent_asset_size <> n.loan_fin_rent_asset_size
        or o.loan_loss_prep_adquy_ratio <> n.loan_loss_prep_adquy_ratio
        or o.group_cust_rela_degree <> n.group_cust_rela_degree
        or o.single_cust_rela_degree <> n.single_cust_rela_degree
        or o.single_cust_centr_degree <> n.single_cust_centr_degree
        or o.dyshard_prt_crdt_centr_degree <> n.dyshard_prt_crdt_centr_degree
        or o.dy_group_cust_crdt_cendegree <> n.dy_group_cust_crdt_cendegree
        or o.dykhjzb_scale <> n.dykhjzb_scale
        or o.dykhrz_scale <> n.dykhrz_scale
        or o.risk_adj_cap_rtn_rat <> n.risk_adj_cap_rtn_rat
        or o.JSDGP_SCALE <> n.JSDGP_SCALE
        or o.net_set_cap_ratio <> n.net_set_cap_ratio
        or o.ljck_scale <> n.ljck_scale
        or o.lcr <> n.lcr
        or o.liqd_match_rat <> n.liqd_match_rat
        or o.buy_rtn_sell_fin_asset <> n.buy_rtn_sell_fin_asset
        or o.pjdl_scale <> n.pjdl_scale
        or o.per_capita_margin <> n.per_capita_margin
        or o.accts_recvbl_class_invest_amt <> n.accts_recvbl_class_invest_amt
        or o.excl_liqd_asset_adquy_ratio <> n.excl_liqd_asset_adquy_ratio
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op(
            flow_num -- 流水号
    ,lp_id -- 法人编号
    ,party_id -- 当事人编号
    ,cust_id -- 客户编号
    ,ind_year -- 指标年度
    ,info_src_descb -- 信息来源描述
    ,tot_asset -- 总资产
    ,net_asset -- 净资产
    ,asset_mgmt_size -- 资产管理规模
    ,dep_size -- 存款规模
    ,loan_size -- 贷款规模
    ,cny_liqd_ratio -- 人民币流动性比例
    ,fcurr_liqd_ratio -- 外币流动性比例
    ,lf_curr_liqd_ratio -- 本外币流动性比例
    ,cny_dep_lon_ratio -- 人民币存贷比例
    ,fcurr_dep_lon_ratio -- 外币存贷比例
    ,lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,cap_stock -- 股本
    ,shard_eqty -- 股东权益
    ,bus_net_inco -- 营业净收入
    ,net_margin -- 净利润
    ,non_asset_rat -- 不良资产率
    ,trust_bus_inco_pct -- 信托业务收入占比
    ,trust_reward_rat -- 信托报酬率
    ,cost_inco_ratio -- 成本收入比
    ,asset_prft_rat -- 资产利润率
    ,cap_prft_rat -- 资本利润率
    ,concern_loan_ratio -- 关注贷款比例
    ,ovdue_loan_ratio -- 逾期贷款比例
    ,npl_ratio -- 不良贷款比例
    ,cap_adquy_ratio -- 资本充足率
    ,pay_back_adquy_ratio -- 偿付能力充足率
    ,risk_cr -- 风险覆盖率
    ,net_stab_fund_ratio -- 净稳定资金率
    ,non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,npl_bal -- 不良贷款余额
    ,conce_loan_bal -- 关注类贷款余额
    ,resv_bal -- 准备金余额
    ,guar_ratio -- 担保比例
    ,sh_term_invest_ratio -- 短期投资比例
    ,lonterm_invest_ratio -- 长期投资比例
    ,ibank_borrow_ratio -- 同业拆入比例
    ,prov_covr -- 拨备覆盖率
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_cty_cd -- 注册国家代码
    ,local_cty_rating -- 所在国家评级
    ,countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate -- 核心一级资本充足率
    ,tieronerate -- 一级资本充足率
    ,capitaladeratio -- 资本充足率
    ,lever_rat -- 杠杆率
    ,ext_audit_opinion -- 外部审计意见
    ,major_risk_flg -- 尽职调查发现存在重大风险标志
    ,update_tm -- 更新时间
    ,fir_create_time -- 首次创建时间
    ,badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,group_cust_rela_degree -- 集团客户关联度
    ,single_cust_rela_degree -- 单一客户关联度
    ,single_cust_centr_degree -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio -- 净稳定资金比例
    ,ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,lcr -- 流动性覆盖率
    ,liqd_match_rat -- 流动性匹配率
    ,buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,pjdl_scale -- 平均代理证券业务净收入
    ,per_capita_margin -- 人均利润
    ,accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.flow_num -- 流水号
    ,o.lp_id -- 法人编号
    ,o.party_id -- 当事人编号
    ,o.cust_id -- 客户编号
    ,o.ind_year -- 指标年度
    ,o.info_src_descb -- 信息来源描述
    ,o.tot_asset -- 总资产
    ,o.net_asset -- 净资产
    ,o.asset_mgmt_size -- 资产管理规模
    ,o.dep_size -- 存款规模
    ,o.loan_size -- 贷款规模
    ,o.cny_liqd_ratio -- 人民币流动性比例
    ,o.fcurr_liqd_ratio -- 外币流动性比例
    ,o.lf_curr_liqd_ratio -- 本外币流动性比例
    ,o.cny_dep_lon_ratio -- 人民币存贷比例
    ,o.fcurr_dep_lon_ratio -- 外币存贷比例
    ,o.lf_curr_dep_lon_ratio -- 本外币存贷比例
    ,o.cap_stock -- 股本
    ,o.shard_eqty -- 股东权益
    ,o.bus_net_inco -- 营业净收入
    ,o.net_margin -- 净利润
    ,o.non_asset_rat -- 不良资产率
    ,o.trust_bus_inco_pct -- 信托业务收入占比
    ,o.trust_reward_rat -- 信托报酬率
    ,o.cost_inco_ratio -- 成本收入比
    ,o.asset_prft_rat -- 资产利润率
    ,o.cap_prft_rat -- 资本利润率
    ,o.concern_loan_ratio -- 关注贷款比例
    ,o.ovdue_loan_ratio -- 逾期贷款比例
    ,o.npl_ratio -- 不良贷款比例
    ,o.cap_adquy_ratio -- 资本充足率
    ,o.pay_back_adquy_ratio -- 偿付能力充足率
    ,o.risk_cr -- 风险覆盖率
    ,o.net_stab_fund_ratio -- 净稳定资金率
    ,o.non_fin_rent_asset_rat -- 不良融资租赁资产率
    ,o.npl_bal -- 不良贷款余额
    ,o.conce_loan_bal -- 关注类贷款余额
    ,o.resv_bal -- 准备金余额
    ,o.guar_ratio -- 担保比例
    ,o.sh_term_invest_ratio -- 短期投资比例
    ,o.lonterm_invest_ratio -- 长期投资比例
    ,o.ibank_borrow_ratio -- 同业拆入比例
    ,o.prov_covr -- 拨备覆盖率
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_cty_cd -- 注册国家代码
    ,o.local_cty_rating -- 所在国家评级
    ,o.countrycapstandard -- 所在国家或地区监管部门的最低资本监管要求
    ,o.countryaddoncapital -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,o.coretieronerate -- 核心一级资本充足率
    ,o.tieronerate -- 一级资本充足率
    ,o.capitaladeratio -- 资本充足率
    ,o.lever_rat -- 杠杆率
    ,o.ext_audit_opinion -- 外部审计意见
    ,o.major_risk_flg -- 尽职调查发现存在重大风险标志
    ,o.update_tm -- 更新时间
    ,o.fir_create_time -- 首次创建时间
    ,o.badrzzl_scale -- 拨备覆盖不良融资租赁资产率
    ,o.npl_and_expe_loan_devit_degree -- 不良贷款与预期贷款偏离度
    ,o.zqjzb_scale -- 持有一种权益类证券的成本与净资本比例
    ,o.zqsz_scale -- 持有一种权益类证券市值与其总市值的比例
    ,o.loan_fin_rent_asset_size -- 贷款/融资租赁资产规模
    ,o.loan_loss_prep_adquy_ratio -- 贷款损失准备充足率
    ,o.group_cust_rela_degree -- 集团客户关联度
    ,o.single_cust_rela_degree -- 单一客户关联度
    ,o.single_cust_centr_degree -- 单一客户集中度
    ,o.dyshard_prt_crdt_centr_degree -- 单一股东及其关联方授信集中度
    ,o.dy_group_cust_crdt_cendegree -- 单一集团客户授信集中度
    ,o.dykhjzb_scale -- 对单一客户融券业务规模与净资本比例
    ,o.dykhrz_scale -- 对单一客户融资业务规模与净资本比例
    ,o.risk_adj_cap_rtn_rat -- 风险调整资本回报率
    ,o.JSDGP_SCALE -- 接受单只担保股票市值与该股票总市值比例
    ,o.net_set_cap_ratio -- 净稳定资金比例
    ,o.ljck_scale -- 累计外汇敞口头寸占资本净额比例
    ,o.lcr -- 流动性覆盖率
    ,o.liqd_match_rat -- 流动性匹配率
    ,o.buy_rtn_sell_fin_asset -- 买入返售金融资产
    ,o.pjdl_scale -- 平均代理证券业务净收入
    ,o.per_capita_margin -- 人均利润
    ,o.accts_recvbl_class_invest_amt -- 应收款项类投资金额
    ,o.excl_liqd_asset_adquy_ratio -- 优质流动性资产充足率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_bk o
    left join ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op n
        on
            o.flow_num = n.flow_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl d
        on
            o.flow_num = d.flow_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_ibank_asset_supv_ind_h;
--alter table ${iml_schema}.pty_ibank_asset_supv_ind_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_ibank_asset_supv_ind_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_ibank_asset_supv_ind_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_ibank_asset_supv_ind_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_ibank_asset_supv_ind_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl;
alter table ${iml_schema}.pty_ibank_asset_supv_ind_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_ibank_asset_supv_ind_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_op purge;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_ibank_asset_supv_ind_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
