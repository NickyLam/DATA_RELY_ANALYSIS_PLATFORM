/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_account_point
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_account_point
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_account_point purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_point(
    id number(30,0) -- 
    ,branch_no varchar2(18) -- 
    ,card_no varchar2(30) -- 
    ,customer_no varchar2(26) -- 
    ,id_card varchar2(48) -- 
    ,custom_type varchar2(30) -- 
    ,card_type varchar2(30) -- 
    ,card_product varchar2(30) -- 
    ,cur_valid_point number(22) -- 
    ,his_valid_point number(22) -- 
    ,total_valid_point number(22) -- 当前可用积分+历史可用积分
    ,used_point number(22) -- 从开卡开始，兑换减少积分+转移转出积分
    ,cut_point_used number(22) -- 
    ,total_point number(22) -- 从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分
    ,due_point number(22) -- 已经做了结转，但是还没做打折的积分
    ,year_used_point number(22) -- 从当年的1月1日开始，兑换减少积分+转移转出积分
    ,discount_date varchar2(12) -- 指打折日期
    ,last_dis_date varchar2(12) -- 
    ,last_init_date varchar2(12) -- 
    ,drop_card_date varchar2(12) -- 
    ,remark varchar2(300) -- 
    ,issue_branch varchar2(8) -- 
    ,last_his_valid_point number(22) -- 
    ,last_ope_time varchar2(21) -- 
    ,last_dis_time varchar2(9) -- 
    ,last_init_time varchar2(9) -- 
    ,customer_name varchar2(192) -- 
    ,point_type varchar2(15) -- 01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；
    ,state varchar2(15) -- 01-正常； 02-冻结；
    ,operator_id varchar2(18) -- 
    ,author_id varchar2(18) -- 
    ,operate_date varchar2(12) -- 
    ,operate_time varchar2(9) -- 
    ,expand_1 varchar2(150) -- 
    ,expand_2 varchar2(150) -- 
    ,expand_3 varchar2(150) -- 
    ,expand_4 varchar2(150) -- 
    ,expand_5 varchar2(150) -- 
    ,is_valid varchar2(2) -- 0-有效 1-失效
    ,author_name varchar2(30) -- 
    ,author_real_name varchar2(30) -- 
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
grant select on ${iol_schema}.cpms_t_account_point to ${iml_schema};
grant select on ${iol_schema}.cpms_t_account_point to ${icl_schema};
grant select on ${iol_schema}.cpms_t_account_point to ${idl_schema};
grant select on ${iol_schema}.cpms_t_account_point to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_account_point is '账户积分余额表';
comment on column ${iol_schema}.cpms_t_account_point.id is '';
comment on column ${iol_schema}.cpms_t_account_point.branch_no is '';
comment on column ${iol_schema}.cpms_t_account_point.card_no is '';
comment on column ${iol_schema}.cpms_t_account_point.customer_no is '';
comment on column ${iol_schema}.cpms_t_account_point.id_card is '';
comment on column ${iol_schema}.cpms_t_account_point.custom_type is '';
comment on column ${iol_schema}.cpms_t_account_point.card_type is '';
comment on column ${iol_schema}.cpms_t_account_point.card_product is '';
comment on column ${iol_schema}.cpms_t_account_point.cur_valid_point is '';
comment on column ${iol_schema}.cpms_t_account_point.his_valid_point is '';
comment on column ${iol_schema}.cpms_t_account_point.total_valid_point is '当前可用积分+历史可用积分';
comment on column ${iol_schema}.cpms_t_account_point.used_point is '从开卡开始，兑换减少积分+转移转出积分';
comment on column ${iol_schema}.cpms_t_account_point.cut_point_used is '';
comment on column ${iol_schema}.cpms_t_account_point.total_point is '从开卡开始，消费增加积分+调整增加积分-调整减少积分+转移转入积分';
comment on column ${iol_schema}.cpms_t_account_point.due_point is '已经做了结转，但是还没做打折的积分';
comment on column ${iol_schema}.cpms_t_account_point.year_used_point is '从当年的1月1日开始，兑换减少积分+转移转出积分';
comment on column ${iol_schema}.cpms_t_account_point.discount_date is '指打折日期';
comment on column ${iol_schema}.cpms_t_account_point.last_dis_date is '';
comment on column ${iol_schema}.cpms_t_account_point.last_init_date is '';
comment on column ${iol_schema}.cpms_t_account_point.drop_card_date is '';
comment on column ${iol_schema}.cpms_t_account_point.remark is '';
comment on column ${iol_schema}.cpms_t_account_point.issue_branch is '';
comment on column ${iol_schema}.cpms_t_account_point.last_his_valid_point is '';
comment on column ${iol_schema}.cpms_t_account_point.last_ope_time is '';
comment on column ${iol_schema}.cpms_t_account_point.last_dis_time is '';
comment on column ${iol_schema}.cpms_t_account_point.last_init_time is '';
comment on column ${iol_schema}.cpms_t_account_point.customer_name is '';
comment on column ${iol_schema}.cpms_t_account_point.point_type is '01-标准积分； 02-个人存款积分； 03-个人贷款积分 ； 04-个人理财积分； 05-红利； 06-里程；';
comment on column ${iol_schema}.cpms_t_account_point.state is '01-正常； 02-冻结；';
comment on column ${iol_schema}.cpms_t_account_point.operator_id is '';
comment on column ${iol_schema}.cpms_t_account_point.author_id is '';
comment on column ${iol_schema}.cpms_t_account_point.operate_date is '';
comment on column ${iol_schema}.cpms_t_account_point.operate_time is '';
comment on column ${iol_schema}.cpms_t_account_point.expand_1 is '';
comment on column ${iol_schema}.cpms_t_account_point.expand_2 is '';
comment on column ${iol_schema}.cpms_t_account_point.expand_3 is '';
comment on column ${iol_schema}.cpms_t_account_point.expand_4 is '';
comment on column ${iol_schema}.cpms_t_account_point.expand_5 is '';
comment on column ${iol_schema}.cpms_t_account_point.is_valid is '0-有效 1-失效';
comment on column ${iol_schema}.cpms_t_account_point.author_name is '';
comment on column ${iol_schema}.cpms_t_account_point.author_real_name is '';
comment on column ${iol_schema}.cpms_t_account_point.start_dt is '开始时间';
comment on column ${iol_schema}.cpms_t_account_point.end_dt is '结束时间';
comment on column ${iol_schema}.cpms_t_account_point.id_mark is '增删标志';
comment on column ${iol_schema}.cpms_t_account_point.etl_timestamp is 'ETL处理时间戳';
