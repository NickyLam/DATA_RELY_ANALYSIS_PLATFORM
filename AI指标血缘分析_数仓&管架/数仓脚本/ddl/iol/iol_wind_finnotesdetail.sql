/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_finnotesdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_finnotesdetail
whenever sqlerror continue none;
drop table ${iol_schema}.wind_finnotesdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_finnotesdetail(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,bd_loss number(20,4) -- 坏账损失
    ,inv_loss number(20,4) -- 存货跌价损失
    ,gi_loss number(20,4) -- 商誉减值损失
    ,gc_loss number(20,4) -- 发放贷款和垫款减值损失
    ,afa_loss number(20,4) -- 可供出售金融资产减值损失
    ,hi_loss number(20,4) -- 持有至到期投资减值损失
    ,oth_loss number(20,4) -- 其他金融资产减值损失
    ,lti_invinc number(20,4) -- 处置长期股权投资产生的投资收益
    ,fat_invinc number(20,4) -- 处置交易性金融资产取得的投资收益
    ,afa_invinc number(20,4) -- 处置可供出售金融资产取得的投资收益
    ,paei_invinc number(20,4) -- 委托投资损益
    ,fel_invinc number(20,4) -- 对外委托贷款取得的收益
    ,cfeo_invinc number(20,4) -- 受托经营取得的托管费收入
    ,othn_invinc number(20,4) -- 其他非经常性投资收益
    ,lti_cost number(20,4) -- 成本法核算的长期股权投资收益
    ,lur_orival number(20,4) -- 土地使用权-原值
    ,lur_acca number(20,4) -- 土地使用权-累计摊销
    ,lur_imp number(20,4) -- 土地使用权-减值准备
    ,lur_bookval number(20,4) -- 土地使用权-账面价值
    ,lti_equ number(20,4) -- 权益法核算的长期股权投资
    ,monf_res number(20,4) -- 受限制的货币资金
    ,sal_cos number(20,4) -- 工资薪酬(销售费用)
    ,sal_gex number(20,4) -- 工资薪酬(管理费用)
    ,da_cos number(20,4) -- 折旧摊销(销售费用)
    ,da_gex number(20,4) -- 折旧摊销(管理费用)
    ,ren_cos number(20,4) -- 租赁费(销售费用)
    ,ren_gex number(20,4) -- 租赁费(管理费用)
    ,stc_cos number(20,4) -- 仓储运输费(销售费用)
    ,ape_cos number(20,4) -- 广告宣传推广费(销售费用)
    ,ltloan_1y number(20,4) -- 1年内到期的长期借款
    ,bondpay_1y number(20,4) -- 1年内到期的应付债券
    ,stfinbond number(20,4) -- 短期融资债(其他流动负债)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_finnotesdetail to ${iml_schema};
grant select on ${iol_schema}.wind_finnotesdetail to ${icl_schema};
grant select on ${iol_schema}.wind_finnotesdetail to ${idl_schema};
grant select on ${iol_schema}.wind_finnotesdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_finnotesdetail is '中国A股财务附注明细';
comment on column ${iol_schema}.wind_finnotesdetail.object_id is '对象ID';
comment on column ${iol_schema}.wind_finnotesdetail.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_finnotesdetail.report_period is '报告期';
comment on column ${iol_schema}.wind_finnotesdetail.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_finnotesdetail.bd_loss is '坏账损失';
comment on column ${iol_schema}.wind_finnotesdetail.inv_loss is '存货跌价损失';
comment on column ${iol_schema}.wind_finnotesdetail.gi_loss is '商誉减值损失';
comment on column ${iol_schema}.wind_finnotesdetail.gc_loss is '发放贷款和垫款减值损失';
comment on column ${iol_schema}.wind_finnotesdetail.afa_loss is '可供出售金融资产减值损失';
comment on column ${iol_schema}.wind_finnotesdetail.hi_loss is '持有至到期投资减值损失';
comment on column ${iol_schema}.wind_finnotesdetail.oth_loss is '其他金融资产减值损失';
comment on column ${iol_schema}.wind_finnotesdetail.lti_invinc is '处置长期股权投资产生的投资收益';
comment on column ${iol_schema}.wind_finnotesdetail.fat_invinc is '处置交易性金融资产取得的投资收益';
comment on column ${iol_schema}.wind_finnotesdetail.afa_invinc is '处置可供出售金融资产取得的投资收益';
comment on column ${iol_schema}.wind_finnotesdetail.paei_invinc is '委托投资损益';
comment on column ${iol_schema}.wind_finnotesdetail.fel_invinc is '对外委托贷款取得的收益';
comment on column ${iol_schema}.wind_finnotesdetail.cfeo_invinc is '受托经营取得的托管费收入';
comment on column ${iol_schema}.wind_finnotesdetail.othn_invinc is '其他非经常性投资收益';
comment on column ${iol_schema}.wind_finnotesdetail.lti_cost is '成本法核算的长期股权投资收益';
comment on column ${iol_schema}.wind_finnotesdetail.lur_orival is '土地使用权-原值';
comment on column ${iol_schema}.wind_finnotesdetail.lur_acca is '土地使用权-累计摊销';
comment on column ${iol_schema}.wind_finnotesdetail.lur_imp is '土地使用权-减值准备';
comment on column ${iol_schema}.wind_finnotesdetail.lur_bookval is '土地使用权-账面价值';
comment on column ${iol_schema}.wind_finnotesdetail.lti_equ is '权益法核算的长期股权投资';
comment on column ${iol_schema}.wind_finnotesdetail.monf_res is '受限制的货币资金';
comment on column ${iol_schema}.wind_finnotesdetail.sal_cos is '工资薪酬(销售费用)';
comment on column ${iol_schema}.wind_finnotesdetail.sal_gex is '工资薪酬(管理费用)';
comment on column ${iol_schema}.wind_finnotesdetail.da_cos is '折旧摊销(销售费用)';
comment on column ${iol_schema}.wind_finnotesdetail.da_gex is '折旧摊销(管理费用)';
comment on column ${iol_schema}.wind_finnotesdetail.ren_cos is '租赁费(销售费用)';
comment on column ${iol_schema}.wind_finnotesdetail.ren_gex is '租赁费(管理费用)';
comment on column ${iol_schema}.wind_finnotesdetail.stc_cos is '仓储运输费(销售费用)';
comment on column ${iol_schema}.wind_finnotesdetail.ape_cos is '广告宣传推广费(销售费用)';
comment on column ${iol_schema}.wind_finnotesdetail.ltloan_1y is '1年内到期的长期借款';
comment on column ${iol_schema}.wind_finnotesdetail.bondpay_1y is '1年内到期的应付债券';
comment on column ${iol_schema}.wind_finnotesdetail.stfinbond is '短期融资债(其他流动负债)';
comment on column ${iol_schema}.wind_finnotesdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_finnotesdetail.etl_timestamp is 'ETL处理时间戳';
