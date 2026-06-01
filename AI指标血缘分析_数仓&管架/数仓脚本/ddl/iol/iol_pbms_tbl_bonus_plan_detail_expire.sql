/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_bonus_plan_detail_expire
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_bonus_plan_detail_expire
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_bonus_plan_detail_expire purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan_detail_expire(
    pk_bonus_plan_detail number(22,0) -- 主键
    ,cust_id varchar2(90) -- 客户号
    ,bonus_plan_type varchar2(6) -- 积分: P 权益星: X
    ,bonus_sub_type varchar2(60) -- 积分二级分类：A001标准积分，A002存款积分，A004理财积分、 X权益星
    ,org_id varchar2(60) -- 成本分摊机构号
    ,total_bonus number(14,0) -- 总积分
    ,valid_bonus number(14,0) -- 可用积分
    ,apply_bonus number(14,0) -- 已用积分
    ,expire_bonus number(14,0) -- 过期积分
    ,freeze_bonus number(14,0) -- 冻结积分
    ,valid_date varchar2(24) -- 有效期(yyyyMMdd)
    ,lock_status varchar2(3) -- 账户状态（1人工冻结 2反洗钱冻结 0正常）
    ,created_by varchar2(60) -- 创建人，系统创建写system
    ,create_time varchar2(90) -- 创建日期时间
    ,updated_by varchar2(60) -- 更新人，系统创建写system
    ,update_time varchar2(90) -- 更新日期时间
    ,del_flag number(22,0) -- 逻辑删除标志(0-正常，1-删除)
    ,deal_flag number(22,0) -- 处理标志：0-未处理过期积分,1-已处理过期积分
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
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_expire to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_expire to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_expire to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_expire to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_bonus_plan_detail_expire is '积分分账过期表';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.pk_bonus_plan_detail is '主键';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.bonus_plan_type is '积分: P 权益星: X';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.bonus_sub_type is '积分二级分类：A001标准积分，A002存款积分，A004理财积分、 X权益星';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.org_id is '成本分摊机构号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.total_bonus is '总积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.valid_bonus is '可用积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.apply_bonus is '已用积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.expire_bonus is '过期积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.freeze_bonus is '冻结积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.valid_date is '有效期(yyyyMMdd)';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.lock_status is '账户状态（1人工冻结 2反洗钱冻结 0正常）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.created_by is '创建人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.create_time is '创建日期时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.updated_by is '更新人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.update_time is '更新日期时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.del_flag is '逻辑删除标志(0-正常，1-删除)';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.deal_flag is '处理标志：0-未处理过期积分,1-已处理过期积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_expire.etl_timestamp is 'ETL处理时间戳';
