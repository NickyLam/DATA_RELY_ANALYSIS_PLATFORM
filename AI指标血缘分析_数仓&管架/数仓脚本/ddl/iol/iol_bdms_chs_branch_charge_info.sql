/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_chs_branch_charge_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_chs_branch_charge_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_chs_branch_charge_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_chs_branch_charge_info(
    id varchar2(60) -- ID
    ,mem_no varchar2(9) -- 会员代码
    ,brh_no varchar2(14) -- 机构代码
    ,charge_period varchar2(9) -- 服务费期数
    ,trans_amt number(18,2) -- 交易手续费计费金额
    ,trans_reb_amt number(18,2) -- 交易手续费优惠金额
    ,settle_amt number(18,2) -- 结算过户费计费金额
    ,settle_reb_amt number(18,2) -- 结算过户费优惠金额
    ,other_amt number(18,2) -- 其他结算费计费金额
    ,other_reb_amt number(18,2) -- 其他结算费优惠金额
    ,account_amt number(18,2) -- 账户维护费计费金额
    ,account_reb_amt number(18,2) -- 账户维护费优惠金额
    ,fee_amt number(18,2) -- 应缴金额
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,top_branch_no varchar2(30) -- 总行机构号
    ,branch_no varchar2(30) -- 机构号
    ,last_upd_opr varchar2(45) -- 最后修改人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,remark varchar2(1500) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_chs_branch_charge_info to ${iml_schema};
grant select on ${iol_schema}.bdms_chs_branch_charge_info to ${icl_schema};
grant select on ${iol_schema}.bdms_chs_branch_charge_info to ${idl_schema};
grant select on ${iol_schema}.bdms_chs_branch_charge_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_chs_branch_charge_info is '票交所机构有偿服务费信息表';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.id is 'ID';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.mem_no is '会员代码';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.charge_period is '服务费期数';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.trans_amt is '交易手续费计费金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.trans_reb_amt is '交易手续费优惠金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.settle_amt is '结算过户费计费金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.settle_reb_amt is '结算过户费优惠金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.other_amt is '其他结算费计费金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.other_reb_amt is '其他结算费优惠金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.account_amt is '账户维护费计费金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.account_reb_amt is '账户维护费优惠金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.fee_amt is '应缴金额';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.branch_no is '机构号';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.last_upd_opr is '最后修改人';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.remark is '备注';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_chs_branch_charge_info.etl_timestamp is 'ETL处理时间戳';
