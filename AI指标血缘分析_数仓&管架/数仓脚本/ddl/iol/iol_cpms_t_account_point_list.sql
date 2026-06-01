/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_account_point_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_account_point_list
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_account_point_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_point_list(
    id number(30,0) -- 
    ,branch_no varchar2(18) -- 
    ,card_no varchar2(30) -- 
    ,customer_no varchar2(26) -- 
    ,custom_type varchar2(3) -- 
    ,consume_date varchar2(12) -- 
    ,consume_time varchar2(9) -- 
    ,merchant_no varchar2(23) -- 
    ,merchant_name varchar2(96) -- 
    ,trans_name varchar2(30) -- 
    ,trans_code varchar2(48) -- 
    ,trans_money number(17,2) -- 
    ,trans_type varchar2(15) -- p-正交易；r-冲正交易；v-撤销交易；l-撤销冲正交易
    ,operate_type varchar2(15) -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10pos兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17pos兑换冲正；18pos兑换撤销；19pos兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,operate_type_name varchar2(75) -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10pos兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17pos兑换冲正；18pos兑换撤销；19pos兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,trans_channel varchar2(2) -- 
    ,sub_trans_channel varchar2(2) -- 
    ,increase_point number(22) -- 
    ,reduce_point number(22) -- 
    ,deduc_money number(17,2) -- 
    ,remain_point number(22) -- 
    ,remark varchar2(384) -- 
    ,operate_date varchar2(12) -- 
    ,operate_time varchar2(9) -- 
    ,operator_id varchar2(18) -- 
    ,author_id varchar2(18) -- 
    ,operator_org varchar2(8) -- 
    ,operate_no varchar2(14) -- 
    ,jrnl_no varchar2(14) -- 
    ,tpcuid varchar2(48) -- 
    ,uuid varchar2(75) -- 
    ,point_time_begin varchar2(12) -- 
    ,summary varchar2(192) -- 
    ,expand_1 varchar2(150) -- 
    ,expand_2 varchar2(150) -- 
    ,expand_3 varchar2(150) -- 
    ,expand_4 varchar2(150) -- 
    ,expand_5 varchar2(150) -- 
    ,is_valid varchar2(2) -- 0-有效 1-失效
    ,last_ope_time varchar2(21) -- 
    ,tran_seq_no_ih varchar2(200) -- 聚合支付流水号
    ,trans_chan varchar2(16) -- 交易渠道
    ,trade_type varchar2(8) -- 交易类型
    ,memo varchar2(2000) -- 备注
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
grant select on ${iol_schema}.cpms_t_account_point_list to ${iml_schema};
grant select on ${iol_schema}.cpms_t_account_point_list to ${icl_schema};
grant select on ${iol_schema}.cpms_t_account_point_list to ${idl_schema};
grant select on ${iol_schema}.cpms_t_account_point_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_account_point_list is '积分明细表';
comment on column ${iol_schema}.cpms_t_account_point_list.id is '';
comment on column ${iol_schema}.cpms_t_account_point_list.branch_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.card_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.customer_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.custom_type is '';
comment on column ${iol_schema}.cpms_t_account_point_list.consume_date is '';
comment on column ${iol_schema}.cpms_t_account_point_list.consume_time is '';
comment on column ${iol_schema}.cpms_t_account_point_list.merchant_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.merchant_name is '';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_name is '';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_code is '';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_money is '';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_type is 'p-正交易；r-冲正交易；v-撤销交易；l-撤销冲正交易';
comment on column ${iol_schema}.cpms_t_account_point_list.operate_type is '01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10pos兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17pos兑换冲正；18pos兑换撤销；19pos兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；';
comment on column ${iol_schema}.cpms_t_account_point_list.operate_type_name is '01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10pos兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17pos兑换冲正；18pos兑换撤销；19pos兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_channel is '';
comment on column ${iol_schema}.cpms_t_account_point_list.sub_trans_channel is '';
comment on column ${iol_schema}.cpms_t_account_point_list.increase_point is '';
comment on column ${iol_schema}.cpms_t_account_point_list.reduce_point is '';
comment on column ${iol_schema}.cpms_t_account_point_list.deduc_money is '';
comment on column ${iol_schema}.cpms_t_account_point_list.remain_point is '';
comment on column ${iol_schema}.cpms_t_account_point_list.remark is '';
comment on column ${iol_schema}.cpms_t_account_point_list.operate_date is '';
comment on column ${iol_schema}.cpms_t_account_point_list.operate_time is '';
comment on column ${iol_schema}.cpms_t_account_point_list.operator_id is '';
comment on column ${iol_schema}.cpms_t_account_point_list.author_id is '';
comment on column ${iol_schema}.cpms_t_account_point_list.operator_org is '';
comment on column ${iol_schema}.cpms_t_account_point_list.operate_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.jrnl_no is '';
comment on column ${iol_schema}.cpms_t_account_point_list.tpcuid is '';
comment on column ${iol_schema}.cpms_t_account_point_list.uuid is '';
comment on column ${iol_schema}.cpms_t_account_point_list.point_time_begin is '';
comment on column ${iol_schema}.cpms_t_account_point_list.summary is '';
comment on column ${iol_schema}.cpms_t_account_point_list.expand_1 is '';
comment on column ${iol_schema}.cpms_t_account_point_list.expand_2 is '';
comment on column ${iol_schema}.cpms_t_account_point_list.expand_3 is '';
comment on column ${iol_schema}.cpms_t_account_point_list.expand_4 is '';
comment on column ${iol_schema}.cpms_t_account_point_list.expand_5 is '';
comment on column ${iol_schema}.cpms_t_account_point_list.is_valid is '0-有效 1-失效';
comment on column ${iol_schema}.cpms_t_account_point_list.last_ope_time is '';
comment on column ${iol_schema}.cpms_t_account_point_list.tran_seq_no_ih is '聚合支付流水号';
comment on column ${iol_schema}.cpms_t_account_point_list.trans_chan is '交易渠道';
comment on column ${iol_schema}.cpms_t_account_point_list.trade_type is '交易类型';
comment on column ${iol_schema}.cpms_t_account_point_list.memo is '备注';
comment on column ${iol_schema}.cpms_t_account_point_list.start_dt is '开始时间';
comment on column ${iol_schema}.cpms_t_account_point_list.end_dt is '结束时间';
comment on column ${iol_schema}.cpms_t_account_point_list.id_mark is '增删标志';
comment on column ${iol_schema}.cpms_t_account_point_list.etl_timestamp is 'ETL处理时间戳';
