/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_pos_termn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_pos_termn_info
whenever sqlerror continue none;
drop table ${iml_schema}.chn_pos_termn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_pos_termn_info(
    chn_id varchar2(60) -- 渠道商终端设备编号
    ,lp_id varchar2(60) -- 法人编号
    ,mercht_id varchar2(60) -- 商户编号
    ,termn_id varchar2(60) -- POS终端号
    ,uniq_mark_id varchar2(60) -- 唯一标示编号
    ,status_cd varchar2(30) -- 状态代码
    ,sign_status_cd varchar2(30) -- 签到状态代码
    ,check_status_cd varchar2(30) -- 审核状态代码
    ,stl_curr_cd varchar2(30) -- 结算币种代码
    ,termn_mcc_code varchar2(45) -- 终端MCC码
    ,manuf_name varchar2(750) -- 厂商名称
    ,termn_model varchar2(100) -- 终端型号
    ,termn_type_cd varchar2(30) -- 终端类型代码
    ,termn_para_dload_flg varchar2(10) -- 终端参数下载标志
    ,ic_card_para_dload_flg varchar2(10) -- IC卡参数下载标志
    ,capk_dload_flg varchar2(10) -- CA公钥下载标志
    ,prop_belong_cd varchar2(10) -- 产权归属代码
    ,prop_belong_org_name varchar2(750) -- 产权所属机构名称
    ,supt_forgn_card_flg varchar2(10) -- 支持外卡标志
    ,forgn_card_org_brand_name varchar2(750) -- 外卡组织品牌名称
    ,supt_ic_card_flg varchar2(10) -- 支持IC卡标志
    ,access_way_cd varchar2(30) -- 接入方式代码
    ,termn_belong_org_id varchar2(100) -- 终端所属机构编号
    ,termn_belong_bank_num varchar2(100) -- 终端所属行号
    ,termn_batch_id varchar2(100) -- 终端批次编号
    ,termn_end_dt varchar2(20) -- 终端批结日期
    ,termn_para varchar2(1500) -- 终端参数
    ,bind_tel_num varchar2(60) -- 绑定电话号码
    ,dist_cd varchar2(30) -- 行政区划代码
    ,termn_install_addr varchar2(750) -- 终端安装地址
    ,phone varchar2(90) -- 联系电话
    ,open_acct_teller varchar2(750) -- 开户柜员
    ,rec_dt date -- 记录日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.chn_pos_termn_info to ${icl_schema};
grant select on ${iml_schema}.chn_pos_termn_info to ${idl_schema};
grant select on ${iml_schema}.chn_pos_termn_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_pos_termn_info is 'POS终端信息';
comment on column ${iml_schema}.chn_pos_termn_info.chn_id is '渠道商终端设备编号';
comment on column ${iml_schema}.chn_pos_termn_info.lp_id is '法人编号';
comment on column ${iml_schema}.chn_pos_termn_info.mercht_id is '商户编号';
comment on column ${iml_schema}.chn_pos_termn_info.termn_id is 'POS终端号';
comment on column ${iml_schema}.chn_pos_termn_info.uniq_mark_id is '唯一标示编号';
comment on column ${iml_schema}.chn_pos_termn_info.status_cd is '状态代码';
comment on column ${iml_schema}.chn_pos_termn_info.sign_status_cd is '签到状态代码';
comment on column ${iml_schema}.chn_pos_termn_info.check_status_cd is '审核状态代码';
comment on column ${iml_schema}.chn_pos_termn_info.stl_curr_cd is '结算币种代码';
comment on column ${iml_schema}.chn_pos_termn_info.termn_mcc_code is '终端MCC码';
comment on column ${iml_schema}.chn_pos_termn_info.manuf_name is '厂商名称';
comment on column ${iml_schema}.chn_pos_termn_info.termn_model is '终端型号';
comment on column ${iml_schema}.chn_pos_termn_info.termn_type_cd is '终端类型代码';
comment on column ${iml_schema}.chn_pos_termn_info.termn_para_dload_flg is '终端参数下载标志';
comment on column ${iml_schema}.chn_pos_termn_info.ic_card_para_dload_flg is 'IC卡参数下载标志';
comment on column ${iml_schema}.chn_pos_termn_info.capk_dload_flg is 'CA公钥下载标志';
comment on column ${iml_schema}.chn_pos_termn_info.prop_belong_cd is '产权归属代码';
comment on column ${iml_schema}.chn_pos_termn_info.prop_belong_org_name is '产权所属机构名称';
comment on column ${iml_schema}.chn_pos_termn_info.supt_forgn_card_flg is '支持外卡标志';
comment on column ${iml_schema}.chn_pos_termn_info.forgn_card_org_brand_name is '外卡组织品牌名称';
comment on column ${iml_schema}.chn_pos_termn_info.supt_ic_card_flg is '支持IC卡标志';
comment on column ${iml_schema}.chn_pos_termn_info.access_way_cd is '接入方式代码';
comment on column ${iml_schema}.chn_pos_termn_info.termn_belong_org_id is '终端所属机构编号';
comment on column ${iml_schema}.chn_pos_termn_info.termn_belong_bank_num is '终端所属行号';
comment on column ${iml_schema}.chn_pos_termn_info.termn_batch_id is '终端批次编号';
comment on column ${iml_schema}.chn_pos_termn_info.termn_end_dt is '终端批结日期';
comment on column ${iml_schema}.chn_pos_termn_info.termn_para is '终端参数';
comment on column ${iml_schema}.chn_pos_termn_info.bind_tel_num is '绑定电话号码';
comment on column ${iml_schema}.chn_pos_termn_info.dist_cd is '行政区划代码';
comment on column ${iml_schema}.chn_pos_termn_info.termn_install_addr is '终端安装地址';
comment on column ${iml_schema}.chn_pos_termn_info.phone is '联系电话';
comment on column ${iml_schema}.chn_pos_termn_info.open_acct_teller is '开户柜员';
comment on column ${iml_schema}.chn_pos_termn_info.rec_dt is '记录日期';
comment on column ${iml_schema}.chn_pos_termn_info.create_dt is '创建日期';
comment on column ${iml_schema}.chn_pos_termn_info.update_dt is '更新日期';
comment on column ${iml_schema}.chn_pos_termn_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.chn_pos_termn_info.id_mark is '增删标志';
comment on column ${iml_schema}.chn_pos_termn_info.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_pos_termn_info.job_cd is '任务编码';
comment on column ${iml_schema}.chn_pos_termn_info.etl_timestamp is 'ETL处理时间戳';
