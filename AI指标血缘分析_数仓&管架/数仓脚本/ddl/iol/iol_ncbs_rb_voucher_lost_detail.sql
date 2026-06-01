/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_lost_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_lost_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_lost_detail(
    payee_name varchar2(200) -- 收款人名称
    ,address varchar2(400) -- 地址
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,agent_tel varchar2(20) -- 经办人电话
    ,commission_client_tel varchar2(20) -- 代办/代理人电话
    ,commission_country varchar2(3) -- 代办人国籍
    ,company varchar2(20) -- 法人
    ,deal_result varchar2(200) -- 处理结果
    ,lost_key varchar2(50) -- 挂失标识符
    ,lost_no varchar2(50) -- 挂失编号
    ,new_prefix varchar2(10) -- 新凭证前缀
    ,prefix varchar2(10) -- 前缀
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,voucher_lost_status varchar2(3) -- 凭证挂失状态
    ,bill_date date -- 本票兑付出票日
    ,bill_lost_time varchar2(26) -- 本票丧失时间
    ,commission_expire_date date -- 交易代办人证件证件失效日期
    ,commission_start_date date -- 代办人证件开始日期
    ,stop_end_date date -- 起始补发日期
    ,stop_start_date date -- 挂失起始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,bill_lost_addr varchar2(400) -- 本票丧失地点
    ,bill_tran_amt number(17,2) -- 出票金额
    ,busi_place varchar2(400) -- 营业场所住所
    ,commission_client_name varchar2(200) -- 代办人名称
    ,commission_document_id varchar2(60) -- 代办人证件号码
    ,commission_document_type varchar2(4) -- 代办人证件类型
    ,new_doc_type varchar2(10) -- 新凭证类型
    ,new_voucher_no varchar2(50) -- 新凭证号码
    ,off_document_id varchar2(60) -- 经办人证件号码
    ,off_document_type varchar2(4) -- 经办人证件类型
    ,operator_name varchar2(200) -- 经办人姓名
    ,unlost_comm_name1 varchar2(200) -- 解挂代办人姓名1
    ,unlost_document_id1 varchar2(60) -- 解挂人证件号码1
    ,unlost_document_type1 varchar2(4) -- 解挂人证件类型1
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,payer_name varchar2(200) -- 付款人名称
    ,lost_person varchar2(3000) -- 挂失止付人
    ,lost_execution varchar2(200) -- 丧失事由
    ,unlost_country varchar2(3) -- 解挂代办人国籍
    ,unlost_phone varchar2(20) -- 解挂代办人联系电话
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
grant select on ${iol_schema}.ncbs_rb_voucher_lost_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_lost_detail is '凭证挂失明细登记簿';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.payee_name is '收款人名称';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.address is '地址';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.agent_tel is '经办人电话';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_client_tel is '代办/代理人电话';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_country is '代办人国籍';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.deal_result is '处理结果';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.lost_key is '挂失标识符';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.lost_no is '挂失编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.new_prefix is '新凭证前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.voucher_lost_status is '凭证挂失状态';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.bill_date is '本票兑付出票日';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.bill_lost_time is '本票丧失时间';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_expire_date is '交易代办人证件证件失效日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_start_date is '代办人证件开始日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.stop_end_date is '起始补发日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.stop_start_date is '挂失起始日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.bill_lost_addr is '本票丧失地点';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.bill_tran_amt is '出票金额';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.busi_place is '营业场所住所';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_client_name is '代办人名称';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_document_id is '代办人证件号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.commission_document_type is '代办人证件类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.new_doc_type is '新凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.new_voucher_no is '新凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.off_document_id is '经办人证件号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.off_document_type is '经办人证件类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.operator_name is '经办人姓名';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.unlost_comm_name1 is '解挂代办人姓名1';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.unlost_document_id1 is '解挂人证件号码1';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.unlost_document_type1 is '解挂人证件类型1';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.payer_name is '付款人名称';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.lost_person is '挂失止付人';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.lost_execution is '丧失事由';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.unlost_country is '解挂代办人国籍';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.unlost_phone is '解挂代办人联系电话';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_voucher_lost_detail.etl_timestamp is 'ETL处理时间戳';
