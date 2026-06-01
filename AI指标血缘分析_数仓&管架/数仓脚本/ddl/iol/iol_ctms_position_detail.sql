/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_position_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_position_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_position_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_position_detail(
    query_date varchar2(12) -- 查询日期
    ,last_modified timestamp -- 操作日期
    ,bond_rating varchar2(48) -- 债券评级
    ,depository_trust varchar2(1536) -- 托管机构
    ,depository_trust_name varchar2(3072) -- 托管机构-名称
    ,dirty_price number -- 全价
    ,fund_rate number -- 可融资质押比(%)
    ,internal_rating varchar2(48) -- 内部评级
    ,inv_group_id varchar2(48) -- 群组编号
    ,inv_group_name varchar2(3072) -- 群组名称
    ,ivt_amount number -- 可用量(万元)
    ,ivt_bl_b number -- 债券借贷融入(万元)
    ,ivt_bl_b_amount number -- 债券借贷融入可用量(万元)
    ,ivt_bond number -- 现券(万元)
    ,ivt_bond_amount number -- 现券可用量(万元)
    ,ivt_cr_b number -- 质押式正回购/协议回购(万元)
    ,ivt_cr_sum number -- 质押券总量(万元) =质押式正回购+债券借贷质押出
    ,ivt_fund_amount number -- 可融资量(万元)
    ,ivt_kr_b number -- 开放式正回购(万元)
    ,ivt_kr_s number -- 开放式逆回购(万元)
    ,ivt_kr_s_amount number -- 开放式逆回购可用量(万元)
    ,ivt_mat_amount number -- 当日到期质押券(万元)
    ,ivt_or_b number -- 买断式正回购(万元)
    ,ivt_or_s number -- 买断式逆回购(万元)
    ,ivt_or_samount number -- 买断式逆回购可用量(万元)
    ,ivt_sl_b number -- 债券借贷质押出(万元)
    ,ivt_sl_s number -- 债券借贷融出(万元)
    ,man_trans_pos number -- 手动调仓量(万元)
    ,market_price number -- 估值净价
    ,maturity_date varchar2(24) -- 债券到期日
    ,portfolio_id varchar2(48) -- 投组编号
    ,portfolio_name varchar2(3072) -- 投组名称
    ,security_id varchar2(48) -- 债券代码
    ,security_name varchar2(3072) -- 债券名称
    ,security_type varchar2(48) -- 债券类别
    ,short_inv varchar2(48) -- 是否短仓
    ,subject_rating varchar2(48) -- 主体评级
    ,trust_bond_sum number -- 托管券总量(万元) = 可用量 + 质押券总量
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
grant select on ${iol_schema}.ctms_position_detail to ${iml_schema};
grant select on ${iol_schema}.ctms_position_detail to ${icl_schema};
grant select on ${iol_schema}.ctms_position_detail to ${idl_schema};
grant select on ${iol_schema}.ctms_position_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_position_detail is '资金现券库存明细';
comment on column ${iol_schema}.ctms_position_detail.query_date is '查询日期';
comment on column ${iol_schema}.ctms_position_detail.last_modified is '操作日期';
comment on column ${iol_schema}.ctms_position_detail.bond_rating is '债券评级';
comment on column ${iol_schema}.ctms_position_detail.depository_trust is '托管机构';
comment on column ${iol_schema}.ctms_position_detail.depository_trust_name is '托管机构-名称';
comment on column ${iol_schema}.ctms_position_detail.dirty_price is '全价';
comment on column ${iol_schema}.ctms_position_detail.fund_rate is '可融资质押比(%)';
comment on column ${iol_schema}.ctms_position_detail.internal_rating is '内部评级';
comment on column ${iol_schema}.ctms_position_detail.inv_group_id is '群组编号';
comment on column ${iol_schema}.ctms_position_detail.inv_group_name is '群组名称';
comment on column ${iol_schema}.ctms_position_detail.ivt_amount is '可用量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_bl_b is '债券借贷融入(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_bl_b_amount is '债券借贷融入可用量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_bond is '现券(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_bond_amount is '现券可用量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_cr_b is '质押式正回购/协议回购(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_cr_sum is '质押券总量(万元) =质押式正回购+债券借贷质押出';
comment on column ${iol_schema}.ctms_position_detail.ivt_fund_amount is '可融资量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_kr_b is '开放式正回购(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_kr_s is '开放式逆回购(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_kr_s_amount is '开放式逆回购可用量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_mat_amount is '当日到期质押券(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_or_b is '买断式正回购(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_or_s is '买断式逆回购(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_or_samount is '买断式逆回购可用量(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_sl_b is '债券借贷质押出(万元)';
comment on column ${iol_schema}.ctms_position_detail.ivt_sl_s is '债券借贷融出(万元)';
comment on column ${iol_schema}.ctms_position_detail.man_trans_pos is '手动调仓量(万元)';
comment on column ${iol_schema}.ctms_position_detail.market_price is '估值净价';
comment on column ${iol_schema}.ctms_position_detail.maturity_date is '债券到期日';
comment on column ${iol_schema}.ctms_position_detail.portfolio_id is '投组编号';
comment on column ${iol_schema}.ctms_position_detail.portfolio_name is '投组名称';
comment on column ${iol_schema}.ctms_position_detail.security_id is '债券代码';
comment on column ${iol_schema}.ctms_position_detail.security_name is '债券名称';
comment on column ${iol_schema}.ctms_position_detail.security_type is '债券类别';
comment on column ${iol_schema}.ctms_position_detail.short_inv is '是否短仓';
comment on column ${iol_schema}.ctms_position_detail.subject_rating is '主体评级';
comment on column ${iol_schema}.ctms_position_detail.trust_bond_sum is '托管券总量(万元) = 可用量 + 质押券总量';
comment on column ${iol_schema}.ctms_position_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_position_detail.etl_timestamp is 'ETL处理时间戳';
