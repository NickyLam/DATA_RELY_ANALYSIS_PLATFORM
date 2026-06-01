/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a0jtpmisaddcrinfo
CreateDate: 20221125
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo(
etl_dt date --数据日期
,mainseq varchar2(16) --中台流水号
,transdt varchar2(8) --交易日期
,status varchar2(2) --交易状态 Z 初始状态 1 已应答
,trantype varchar2(3) --交易类型
,bank_self_num varchar2(50) --银行自身流水号
,biz_type_code varchar2(2) --业务类型代码
,idtype_code varchar2(4) --
,idcode varchar2(50) --证件号码
,ctycode varchar2(3) --国家/地区代码
,add_idcode varchar2(50) --补充证件号码
,person_name varchar2(256) --姓名
,biz_tx_chnl_code varchar2(2) --务办理渠道代码
,txccy varchar2(3) --币种
,cr_amt varchar2(18) --存钞金额
,acct_no varchar2(35) --个人外汇账户账号
,remark varchar2(512) --备注
,refno varchar2(50) --业务参号
,code varchar2(6) --代码
,detail varchar2(512) --错误详细信息
,cr_amt_date varchar2(18) --当日已存入金额（折美元）
,cr_amt_year varchar2(18) --当年已存入金额（折美元）
,src varchar2(6) --发起节点代码
,des varchar2(9) --接收节点代码
,sendtime varchar2(20) --发送时间
,common_org_code varchar2(12) --机构代码
,msgno varchar2(33) --报文参考号
,transmessage varchar2(200) --交易信息
,edit_reason_code varchar2(3) --修改/撤销原因代码
,edit_remark varchar2(256) --修改/撤销原因说明
,brcno varchar2(8) --机构号
,tlrno varchar2(8) --柜员
,srcseqno varchar2(64) --
,etl_timestamp timestamp(6) -- 任务处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo is '外币存入信息表';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.mainseq is '中台流水号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.status is '交易状态 Z 初始状态 1 已应答';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.trantype is '交易类型';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.bank_self_num is '银行自身流水号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.biz_type_code is '业务类型代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.idtype_code is '';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.idcode is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.ctycode is '国家/地区代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.add_idcode is '补充证件号码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.person_name is '姓名';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.biz_tx_chnl_code is '务办理渠道代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.txccy is '币种';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.cr_amt is '存钞金额';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.acct_no is '个人外汇账户账号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.remark is '备注';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.refno is '业务参号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.code is '代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.detail is '错误详细信息';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.cr_amt_date is '当日已存入金额（折美元）';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.cr_amt_year is '当年已存入金额（折美元）';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.src is '发起节点代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.des is '接收节点代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.sendtime is '发送时间';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.common_org_code is '机构代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.msgno is '报文参考号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.transmessage is '交易信息';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.edit_reason_code is '修改/撤销原因代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.edit_remark is '修改/撤销原因说明';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.brcno is '机构号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.tlrno is '柜员';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisaddcrinfo.srcseqno is '';

