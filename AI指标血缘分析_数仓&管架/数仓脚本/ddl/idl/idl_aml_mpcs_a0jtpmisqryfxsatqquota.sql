/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a0jtpmisqryfxsatqquota
CreateDate: 20221228
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota(
etl_dt date --数据日期
,mainseq varchar2(16) --中台流水号
,transdt varchar2(8) --交易日期
,status varchar2(2) --交易状态 Z 初始状态 0-发送失败 1 发送成功
,trantype varchar2(2) --交易类型 JH结汇 GH购汇
,idtype_code varchar2(4) --
,idcode varchar2(30) --证件号码
,ctycode varchar2(3) --国家/地区代码
,ann_lcyamt_usd varchar2(18) --本年额度内已结汇金额折美元
,ann_rem_lcyamt_usd varchar2(18) --本年额度内剩余可结汇金额折美元
,cr_amt_usd_sumday varchar2(18) --当日已存入金额折美元
,cr_amt_usd_sumyear varchar2(18) --当年已存入金额折美元
,ann_fcyamt_usd varchar2(18) --本年额度内已购汇金额折美元
,ann_rem_fcyamt_usd varchar2(18) --本年额度内剩余可购汇金额折美元
,zq_amt_usd_date varchar2(18) --当日已提取金额（折美元）
,zq_amt_usd_year varchar2(18) --当年已提取金额（折美元）
,custname varchar2(128) --交易主体姓名
,custtype_code varchar2(2) --交易主体类型代码
,type_status varchar2(2) --个人主体分类状态代码
,pub_date varchar2(8) --发布日期
,end_date varchar2(8) --到期日期
,pub_reason varchar2(256) --发布原因
,pub_code varchar2(2) --发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
,pub_org varchar2(256) --关注名单发布机构
,sign_status varchar2(1) --风险提示函/告知书告知状态 0未告知1已告知
,is_check varchar2(1) --是否是待核查处理个人  Y 是/ N 否
,is_notice varchar2(1) --待核查处理个人是否已告知 Y 是/ N 否
,check_pub_date varchar2(8) --待核查处理个人发布日期
,check_end_date varchar2(8) --待核查处理个人到期日期
,check_pub_reason varchar2(256) --待核查处理个人发布原因
,check_pub_code varchar2(2) --待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
,check_pub_branch varchar2(256) --待核查处理个人发布机构
,magebrn varchar2(8) --机构号
,oprtlr varchar2(8) --柜员号
,fronttrcd varchar2(20) --中台交易码
,servicepath varchar2(100) --访问服务信息
,remark varchar2(256) --备注
,src varchar2(6) --发起节点代码
,des varchar2(9) --接收节点代码
,sendtime varchar2(20) --发送时间
,common_org_code varchar2(12) --机构代码
,msgno varchar2(33) --报文参考号
,zyed_flag varchar2(1) --占用额度标识 0是占用额度,1非占用额度
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
grant select on ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota is '结售汇额度信息查询表';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.mainseq is '中台流水号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.status is '交易状态 Z 初始状态 0-发送失败 1 发送成功';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.trantype is '交易类型 JH结汇 GH购汇';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.idtype_code is '';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.idcode is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.ctycode is '国家/地区代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.ann_lcyamt_usd is '本年额度内已结汇金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.ann_rem_lcyamt_usd is '本年额度内剩余可结汇金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.cr_amt_usd_sumday is '当日已存入金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.cr_amt_usd_sumyear is '当年已存入金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.ann_fcyamt_usd is '本年额度内已购汇金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.ann_rem_fcyamt_usd is '本年额度内剩余可购汇金额折美元';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.zq_amt_usd_date is '当日已提取金额（折美元）';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.zq_amt_usd_year is '当年已提取金额（折美元）';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.custname is '交易主体姓名';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.custtype_code is '交易主体类型代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.type_status is '个人主体分类状态代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.pub_date is '发布日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.end_date is '到期日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.pub_reason is '发布原因';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.pub_code is '发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.pub_org is '关注名单发布机构';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.sign_status is '风险提示函/告知书告知状态 0未告知1已告知';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.is_check is '是否是待核查处理个人  Y 是/ N 否';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.is_notice is '待核查处理个人是否已告知 Y 是/ N 否';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.check_pub_date is '待核查处理个人发布日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.check_end_date is '待核查处理个人到期日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.check_pub_reason is '待核查处理个人发布原因';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.check_pub_code is '待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.check_pub_branch is '待核查处理个人发布机构';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.magebrn is '机构号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.oprtlr is '柜员号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.fronttrcd is '中台交易码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.servicepath is '访问服务信息';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.remark is '备注';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.src is '发起节点代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.des is '接收节点代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.sendtime is '发送时间';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.common_org_code is '机构代码';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.msgno is '报文参考号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqryfxsatqquota.zyed_flag is '占用额度标识 0是占用额度,1非占用额度';

