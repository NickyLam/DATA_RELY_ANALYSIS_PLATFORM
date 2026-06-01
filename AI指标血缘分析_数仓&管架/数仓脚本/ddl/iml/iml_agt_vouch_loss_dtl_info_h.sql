/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_vouch_loss_dtl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_vouch_loss_dtl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_vouch_loss_dtl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_vouch_loss_dtl_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,loss_idf varchar2(60) -- 挂失标识符
    ,loss_id varchar2(100) -- 挂失编号
    ,seq_num varchar2(60) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,loss_begin_dt date -- 挂失起始日期
    ,reissue_begin_dt date -- 补发起始日期
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_begin_num varchar2(60) -- 凭证起始号码
    ,vouch_termnt_num varchar2(60) -- 凭证终止号码
    ,new_vouch_type_cd varchar2(30) -- 新凭证类型代码
    ,new_vouch_no varchar2(60) -- 新凭证号码
    ,vouch_loss_status_cd varchar2(30) -- 凭证挂失状态代码
    ,chn_id varchar2(100) -- 渠道编号
    ,tran_tm timestamp -- 交易时间
    ,public_agent_name varchar2(500) -- 代办人名称
    ,public_agent_nation varchar2(30) -- 代办人国籍
    ,public_agent_cert_type_cd varchar2(30) -- 代办人证件类型代码
    ,public_agent_cert_no varchar2(60) -- 代办人证件号码
    ,public_agent_tel_num varchar2(60) -- 代办人电话号码
    ,unloss_public_agent_name varchar2(500) -- 解挂代办人姓名
    ,unloss_public_agent_nation varchar2(30) -- 解挂代办人国籍
    ,unloss_public_agent_cert_type_cd varchar2(30) -- 解挂代办人证件类型代码
    ,unloss_public_agent_cert_no varchar2(60) -- 解挂代办人证件号码
    ,unloss_public_agent_phone varchar2(60) -- 解挂代办人联系电话
    ,operr_cert_no varchar2(500) -- 经办人证件号码
    ,operr_cert_type_cd varchar2(500) -- 经办人证件类型代码
    ,operr_name varchar2(500) -- 经办人姓名
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_vouch_loss_dtl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_vouch_loss_dtl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_vouch_loss_dtl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_vouch_loss_dtl_info_h is '凭证挂失明细信息历史';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.loss_idf is '挂失标识符';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.loss_id is '挂失编号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.seq_num is '序号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.loss_begin_dt is '挂失起始日期';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.reissue_begin_dt is '补发起始日期';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.vouch_begin_num is '凭证起始号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.vouch_termnt_num is '凭证终止号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.new_vouch_type_cd is '新凭证类型代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.new_vouch_no is '新凭证号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.vouch_loss_status_cd is '凭证挂失状态代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.public_agent_name is '代办人名称';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.public_agent_nation is '代办人国籍';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.public_agent_cert_type_cd is '代办人证件类型代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.public_agent_cert_no is '代办人证件号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.public_agent_tel_num is '代办人电话号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.unloss_public_agent_name is '解挂代办人姓名';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.unloss_public_agent_nation is '解挂代办人国籍';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.unloss_public_agent_cert_type_cd is '解挂代办人证件类型代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.unloss_public_agent_cert_no is '解挂代办人证件号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.unloss_public_agent_phone is '解挂代办人联系电话';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.operr_cert_no is '经办人证件号码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.operr_name is '经办人姓名';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_vouch_loss_dtl_info_h.etl_timestamp is 'ETL处理时间戳';
