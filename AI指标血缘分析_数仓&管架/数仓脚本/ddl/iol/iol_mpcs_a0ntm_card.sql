/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_card
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_card
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_card purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_card(
    org varchar2(18) -- 机构号
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,acct_no number(20,0) -- 账户编号
    ,cust_id number(20,0) -- 客户编号
    ,corp_id varchar2(90) -- 公司id
    ,product_cd varchar2(9) -- 产品代码
    ,app_no varchar2(30) -- 申请件编号
    ,barcode varchar2(90) -- 申请书条码
    ,bsc_supp_ind varchar2(90) -- 主附卡指示
    ,bsc_logiccard_no varchar2(29) -- 逻辑卡主卡卡号
    ,owning_branch varchar2(90) -- 发卡网点
    ,app_promotion_cd varchar2(90) -- 促销码
    ,recom_name varchar2(90) -- 推荐人姓名
    ,recom_card_no varchar2(90) -- 推荐人介质卡号
    ,setup_date date -- 创建日期
    ,user_field21 varchar2(90) -- 系统备用域21
    ,activate_ind varchar2(2) -- 是否已激活
    ,cancel_date date -- 销卡销户日期
    ,latest_card_no varchar2(29) -- 最新介质卡号
    ,sales_ind varchar2(90) -- 是否接受推广邮件
    ,buser_field22 varchar2(90) -- 系统备用域22
    ,represent_name varchar2(120) -- 客户经理
    ,pos_pin_verify_ind varchar2(90) -- 是否消费凭密
    ,relationship_to_bsc varchar2(90) -- 与主卡持卡人关系
    ,card_expire_date date -- 卡片有效日期
    ,card_fee_rate number(19,6) -- 年费收取比例
    ,renew_ind varchar2(90) -- 续卡标识
    ,renew_reject_cd varchar2(90) -- 续卡拒绝原因码
    ,first_card_fee_date date -- 首次年费收取日期
    ,last_renewal_date date -- 上次续卡日期
    ,first_usage_flag varchar2(90) -- 卡片首次用卡标志
    ,next_card_fee_date date -- 下个年费收取日期
    ,waive_cardfee_ind varchar2(90) -- 是否免除年费
    ,card_fetch_method varchar2(90) -- 介质卡领取方式
    ,card_mailer_ind varchar2(90) -- 卡片寄送地址标志
    ,jpa_version number(22) -- 乐观锁版本号
    ,first_usage_date date -- 首次用卡日期
    ,buser_field23 date -- 系统备用域23
    ,buser_field24 date -- 系统备用域24
    ,buser_field25 date -- 系统备用域25
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0ntm_card to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_card to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_card to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_card to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_card is '逻辑卡表';
comment on column ${iol_schema}.mpcs_a0ntm_card.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_card.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0ntm_card.acct_no is '账户编号';
comment on column ${iol_schema}.mpcs_a0ntm_card.cust_id is '客户编号';
comment on column ${iol_schema}.mpcs_a0ntm_card.corp_id is '公司id';
comment on column ${iol_schema}.mpcs_a0ntm_card.product_cd is '产品代码';
comment on column ${iol_schema}.mpcs_a0ntm_card.app_no is '申请件编号';
comment on column ${iol_schema}.mpcs_a0ntm_card.barcode is '申请书条码';
comment on column ${iol_schema}.mpcs_a0ntm_card.bsc_supp_ind is '主附卡指示';
comment on column ${iol_schema}.mpcs_a0ntm_card.bsc_logiccard_no is '逻辑卡主卡卡号';
comment on column ${iol_schema}.mpcs_a0ntm_card.owning_branch is '发卡网点';
comment on column ${iol_schema}.mpcs_a0ntm_card.app_promotion_cd is '促销码';
comment on column ${iol_schema}.mpcs_a0ntm_card.recom_name is '推荐人姓名';
comment on column ${iol_schema}.mpcs_a0ntm_card.recom_card_no is '推荐人介质卡号';
comment on column ${iol_schema}.mpcs_a0ntm_card.setup_date is '创建日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.user_field21 is '系统备用域21';
comment on column ${iol_schema}.mpcs_a0ntm_card.activate_ind is '是否已激活';
comment on column ${iol_schema}.mpcs_a0ntm_card.cancel_date is '销卡销户日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.latest_card_no is '最新介质卡号';
comment on column ${iol_schema}.mpcs_a0ntm_card.sales_ind is '是否接受推广邮件';
comment on column ${iol_schema}.mpcs_a0ntm_card.buser_field22 is '系统备用域22';
comment on column ${iol_schema}.mpcs_a0ntm_card.represent_name is '客户经理';
comment on column ${iol_schema}.mpcs_a0ntm_card.pos_pin_verify_ind is '是否消费凭密';
comment on column ${iol_schema}.mpcs_a0ntm_card.relationship_to_bsc is '与主卡持卡人关系';
comment on column ${iol_schema}.mpcs_a0ntm_card.card_expire_date is '卡片有效日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.card_fee_rate is '年费收取比例';
comment on column ${iol_schema}.mpcs_a0ntm_card.renew_ind is '续卡标识';
comment on column ${iol_schema}.mpcs_a0ntm_card.renew_reject_cd is '续卡拒绝原因码';
comment on column ${iol_schema}.mpcs_a0ntm_card.first_card_fee_date is '首次年费收取日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.last_renewal_date is '上次续卡日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.first_usage_flag is '卡片首次用卡标志';
comment on column ${iol_schema}.mpcs_a0ntm_card.next_card_fee_date is '下个年费收取日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.waive_cardfee_ind is '是否免除年费';
comment on column ${iol_schema}.mpcs_a0ntm_card.card_fetch_method is '介质卡领取方式';
comment on column ${iol_schema}.mpcs_a0ntm_card.card_mailer_ind is '卡片寄送地址标志';
comment on column ${iol_schema}.mpcs_a0ntm_card.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_card.first_usage_date is '首次用卡日期';
comment on column ${iol_schema}.mpcs_a0ntm_card.buser_field23 is '系统备用域23';
comment on column ${iol_schema}.mpcs_a0ntm_card.buser_field24 is '系统备用域24';
comment on column ${iol_schema}.mpcs_a0ntm_card.buser_field25 is '系统备用域25';
comment on column ${iol_schema}.mpcs_a0ntm_card.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_card.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_card.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_card.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_card.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_card.etl_timestamp is 'ETL处理时间戳';
