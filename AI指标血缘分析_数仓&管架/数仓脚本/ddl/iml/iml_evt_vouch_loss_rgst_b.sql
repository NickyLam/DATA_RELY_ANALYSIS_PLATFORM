/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_vouch_loss_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_vouch_loss_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_vouch_loss_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_loss_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,loss_idf varchar2(60) -- 挂失标识符
    ,loss_id varchar2(100) -- 挂失编号
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,acct_name varchar2(500) -- 账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,vouch_loss_cate_cd varchar2(30) -- 凭证挂失类别代码
    ,vouch_loss_status_cd varchar2(30) -- 凭证挂失状态代码
    ,froz_start_seq_num varchar2(60) -- 冻结开始序号
    ,vouch_tran_froz_flg varchar2(10) -- 凭证交易冻结标志
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,chn_id varchar2(100) -- 渠道编号
    ,loss_unloss_rs varchar2(500) -- 挂失解挂原因
    ,unloss_type_cd varchar2(30) -- 解挂类型代码
    ,unloss_dt date -- 解挂日期
    ,unloss_org_id varchar2(100) -- 解挂机构编号
    ,unloss_auth_teller_id varchar2(100) -- 解挂授权柜员编号
    ,unloss_teller_id varchar2(100) -- 解挂柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,rest_descb varchar2(500) -- 处理结果描述
    ,dfoget_pwd_flg varchar2(10) -- 忘记密码标志
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_vouch_loss_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_vouch_loss_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_vouch_loss_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_vouch_loss_rgst_b is '凭证挂失登记簿';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.loss_idf is '挂失标识符';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.loss_id is '挂失编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.prod_id is '产品编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.acct_name is '账户名称';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.cust_id is '客户编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.vouch_loss_cate_cd is '凭证挂失类别代码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.vouch_loss_status_cd is '凭证挂失状态代码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.froz_start_seq_num is '冻结开始序号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.vouch_tran_froz_flg is '凭证交易冻结标志';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.loss_unloss_rs is '挂失解挂原因';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.unloss_type_cd is '解挂类型代码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.unloss_dt is '解挂日期';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.unloss_org_id is '解挂机构编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.unloss_auth_teller_id is '解挂授权柜员编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.unloss_teller_id is '解挂柜员编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.rest_descb is '处理结果描述';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.dfoget_pwd_flg is '忘记密码标志';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_vouch_loss_rgst_b.etl_timestamp is 'ETL处理时间戳';
