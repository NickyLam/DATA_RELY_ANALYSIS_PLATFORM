/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_jh_mcht_inf_tmp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp(
    agent_cd varchar2(15) -- 代理编号
    ,mcht_no varchar2(15) -- 商户号
    ,mcht_nm varchar2(150) -- 商户名称
    ,mcht_cn_abbr varchar2(60) -- 中文名称简写
    ,spell_name varchar2(30) -- 商户拼音缩写
    ,eng_name varchar2(60) -- 商户英文名称
    ,mcht_en_abbr varchar2(20) -- 商户英文名称缩写
    ,license_type varchar2(32) -- 证件类型
    ,licence_no varchar2(20) -- 证件编号号码
    ,licence_end_date varchar2(8) -- 证件有效期
    ,mcht_lvl varchar2(1) -- 商户级别
    ,contact varchar2(30) -- 联系人姓名
    ,contact_class varchar2(20) -- 联系人类型
    ,comm_email varchar2(40) -- 联系人电子邮箱
    ,comm_mobil varchar2(20) -- 客户电话
    ,comm_tel varchar2(18) -- 联系人电话
    ,addr varchar2(386) -- 联系人地址
    ,manager varchar2(50) -- 法人姓名
    ,artif_certif_tp varchar2(20) -- 法人证件类型
    ,identity_no varchar2(20) -- 联系人证件号码
    ,manager_tel varchar2(12) -- 法人联系电话
    ,post_code varchar2(6) -- 邮编
    ,fax varchar2(20) -- 传真
    ,area_no varchar2(6) -- 区域代码
    ,mcht_eng_city_name varchar2(60) -- 商户所在城市
    ,mcht_key varchar2(32) -- 商户密钥
    ,oper_no varchar2(8) -- 客户经理工号
    ,oper_nm varchar2(10) -- 客户经理姓名
    ,mcht_status varchar2(10) -- 商户状态
    ,risl_lvl varchar2(1) -- 商户风险级别
    ,reg_addr varchar2(60) -- 注册地址
    ,bank_licence_no varchar2(20) -- 机构代码证号码
    ,bus_type varchar2(4) -- 营业性质
    ,fax_no varchar2(20) -- 税务登记证号码
    ,bus_amt varchar2(12) -- 注册资金
    ,mcht_cre_lvl varchar2(4) -- 企业资质等级
    ,apply_date varchar2(8) -- 申请日期
    ,enable_date varchar2(8) -- 启用日期
    ,pre_aud_nm varchar2(40) -- 初审人
    ,confirm_nm varchar2(40) -- 批准人
    ,protocal_id varchar2(20) -- 协议编号
    ,sign_inst_id varchar2(13) -- 签约机构代码(银联分配机构号)
    ,net_nm varchar2(30) -- 隶属网点代码
    ,agr_br varchar2(6) -- 签约网点
    ,net_tel varchar2(18) -- 网点电话
    ,prol_date varchar2(8) -- 签约日期
    ,prol_tlr varchar2(8) -- 签约柜员
    ,close_date varchar2(8) -- 撤消签约日期
    ,close_tlr varchar2(7) -- 撤消签约柜员
    ,main_tlr varchar2(8) -- 维护柜员
    ,check_tlr varchar2(8) -- 复核柜员
    ,acq_inst_id varchar2(13) -- 商户所属机构代码
    ,acq_bk_name varchar2(30) -- 收单行名称
    ,bank_no varchar2(6) -- 分行号
    ,mcht_secret varchar2(32) -- 商户秘钥
    ,reserved varchar2(60) -- 保留
    ,upd_opr_id varchar2(40) -- 修改记录操作员
    ,crt_opr_id varchar2(40) -- 创建记录操作员
    ,rec_upd_ts varchar2(14) -- 记录修改时间
    ,rec_crt_ts varchar2(14) -- 记录创建时间
    ,province_code varchar2(20) -- 省份编码
    ,city_code varchar2(20) -- 城市编码
    ,district_code varchar2(20) -- 区域编码
    ,legal_person_id_card varchar2(20) -- 法人证件号码
    ,flow_bank_no varchar2(30) -- 流程银行流水号
    ,flow_bank_status varchar2(1) -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
    ,flow_bank_reserved varchar2(256) -- 流程银行审批描述
    ,h5_flow_flag varchar2(1) -- h5标识 ，1-h5渠道
    ,risk_statu varchar2(1) -- 
    ,mq_statu varchar2(1) -- 
    ,risk_describe varchar2(512) -- 
    ,risk_flag varchar2(66) -- 
    ,out_mcht_no varchar2(32) -- 
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
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp is '聚合商户表临时表';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.agent_cd is '代理编号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_nm is '商户名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_cn_abbr is '中文名称简写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.spell_name is '商户拼音缩写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.eng_name is '商户英文名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_en_abbr is '商户英文名称缩写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.license_type is '证件类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.licence_no is '证件编号号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.licence_end_date is '证件有效期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_lvl is '商户级别';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.contact is '联系人姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.contact_class is '联系人类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.comm_email is '联系人电子邮箱';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.comm_mobil is '客户电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.comm_tel is '联系人电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.addr is '联系人地址';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.manager is '法人姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.artif_certif_tp is '法人证件类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.identity_no is '联系人证件号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.manager_tel is '法人联系电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.post_code is '邮编';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.fax is '传真';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.area_no is '区域代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_eng_city_name is '商户所在城市';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_key is '商户密钥';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.oper_no is '客户经理工号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.oper_nm is '客户经理姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_status is '商户状态';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.risl_lvl is '商户风险级别';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.reg_addr is '注册地址';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.bank_licence_no is '机构代码证号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.bus_type is '营业性质';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.fax_no is '税务登记证号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.bus_amt is '注册资金';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_cre_lvl is '企业资质等级';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.apply_date is '申请日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.enable_date is '启用日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.pre_aud_nm is '初审人';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.confirm_nm is '批准人';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.protocal_id is '协议编号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.sign_inst_id is '签约机构代码(银联分配机构号)';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.net_nm is '隶属网点代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.agr_br is '签约网点';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.net_tel is '网点电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.prol_date is '签约日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.prol_tlr is '签约柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.close_date is '撤消签约日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.close_tlr is '撤消签约柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.main_tlr is '维护柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.check_tlr is '复核柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.acq_inst_id is '商户所属机构代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.acq_bk_name is '收单行名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.bank_no is '分行号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mcht_secret is '商户秘钥';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.reserved is '保留';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.upd_opr_id is '修改记录操作员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.crt_opr_id is '创建记录操作员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.rec_upd_ts is '记录修改时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.rec_crt_ts is '记录创建时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.province_code is '省份编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.city_code is '城市编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.district_code is '区域编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.legal_person_id_card is '法人证件号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.flow_bank_no is '流程银行流水号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.flow_bank_status is '流程银行审批结果,0-初始状态1-审批通过2-审批不通过';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.flow_bank_reserved is '流程银行审批描述';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.h5_flow_flag is 'h5标识 ，1-h5渠道';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.risk_statu is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.mq_statu is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.risk_describe is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.risk_flag is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf_tmp.etl_timestamp is 'ETL处理时间戳';
