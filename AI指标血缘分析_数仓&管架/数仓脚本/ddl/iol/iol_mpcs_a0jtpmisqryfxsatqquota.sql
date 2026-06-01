/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0jtpmisqryfxsatqquota
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,status varchar2(3) -- 交易状态 z 初始状态 0-发送失败 1 发送成功
    ,trantype varchar2(3) -- 交易类型 jh结汇 gh购汇
    ,idtype_code varchar2(6) -- 证件类型
    ,idcode varchar2(45) -- 证件号码
    ,ctycode varchar2(5) -- 国家/地区代码
    ,ann_lcyamt_usd varchar2(27) -- 本年额度内已结汇金额折美元
    ,ann_rem_lcyamt_usd varchar2(27) -- 本年额度内剩余可结汇金额折美元
    ,cr_amt_usd_sumday varchar2(27) -- 当日已存入金额折美元
    ,cr_amt_usd_sumyear varchar2(27) -- 当年已存入金额折美元
    ,ann_fcyamt_usd varchar2(27) -- 本年额度内已购汇金额折美元
    ,ann_rem_fcyamt_usd varchar2(27) -- 本年额度内剩余可购汇金额折美元
    ,zq_amt_usd_date varchar2(27) -- 当日已提取金额（折美元）
    ,zq_amt_usd_year varchar2(27) -- 当年已提取金额（折美元）
    ,custname varchar2(192) -- 交易主体姓名
    ,custtype_code varchar2(3) -- 交易主体类型代码
    ,type_status varchar2(3) -- 个人主体分类状态代码
    ,pub_date varchar2(12) -- 发布日期
    ,end_date varchar2(12) -- 到期日期
    ,pub_reason varchar2(384) -- 发布原因
    ,pub_code varchar2(3) -- 发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他
    ,pub_org varchar2(384) -- 关注名单发布机构
    ,sign_status varchar2(2) -- 风险提示函/告知书告知状态 0未告知1已告知
    ,is_check varchar2(2) -- 是否是待核查处理个人  y 是/ n 否
    ,is_notice varchar2(2) -- 待核查处理个人是否已告知 y 是/ n 否
    ,check_pub_date varchar2(12) -- 待核查处理个人发布日期
    ,check_end_date varchar2(12) -- 待核查处理个人到期日期
    ,check_pub_reason varchar2(384) -- 待核查处理个人发布原因
    ,check_pub_code varchar2(3) -- 待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务
    ,check_pub_branch varchar2(384) -- 待核查处理个人发布机构
    ,magebrn varchar2(12) -- 机构号
    ,oprtlr varchar2(12) -- 柜员号
    ,fronttrcd varchar2(30) -- 中台交易码
    ,servicepath varchar2(150) -- 访问服务信息
    ,remark varchar2(384) -- 备注
    ,src varchar2(9) -- 发起节点代码
    ,des varchar2(14) -- 接收节点代码
    ,sendtime varchar2(30) -- 发送时间
    ,common_org_code varchar2(18) -- 机构代码
    ,msgno varchar2(50) -- 报文参考号
    ,zyed_flag varchar2(2) -- 占用额度标识 0是占用额度,1非占用额度
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
grant select on ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota is '';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.status is '交易状态 z 初始状态 0-发送失败 1 发送成功';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.trantype is '交易类型 jh结汇 gh购汇';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.idtype_code is '证件类型';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.idcode is '证件号码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.ctycode is '国家/地区代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.ann_lcyamt_usd is '本年额度内已结汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.ann_rem_lcyamt_usd is '本年额度内剩余可结汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.cr_amt_usd_sumday is '当日已存入金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.cr_amt_usd_sumyear is '当年已存入金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.ann_fcyamt_usd is '本年额度内已购汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.ann_rem_fcyamt_usd is '本年额度内剩余可购汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.zq_amt_usd_date is '当日已提取金额（折美元）';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.zq_amt_usd_year is '当年已提取金额（折美元）';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.custname is '交易主体姓名';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.custtype_code is '交易主体类型代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.type_status is '个人主体分类状态代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.pub_date is '发布日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.end_date is '到期日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.pub_reason is '发布原因';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.pub_code is '发布原因代码 01分拆收结汇境外汇款人02分拆收结汇参与者03分拆收结汇资金归集者04分拆购付汇资金提供者05-分拆购付汇参与者06分拆购付汇境外收款人07多次协助他人规避额度及真实性管理99其他';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.pub_org is '关注名单发布机构';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.sign_status is '风险提示函/告知书告知状态 0未告知1已告知';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.is_check is '是否是待核查处理个人  y 是/ n 否';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.is_notice is '待核查处理个人是否已告知 y 是/ n 否';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.check_pub_date is '待核查处理个人发布日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.check_end_date is '待核查处理个人到期日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.check_pub_reason is '待核查处理个人发布原因';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.check_pub_code is '待核查处理个人发布原因代码 01可疑现钞业务 02可疑结售汇业务 03可疑收支业务 04虚假申报信息 05其他业务';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.check_pub_branch is '待核查处理个人发布机构';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.magebrn is '机构号';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.oprtlr is '柜员号';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.servicepath is '访问服务信息';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.remark is '备注';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.src is '发起节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.des is '接收节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.sendtime is '发送时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.common_org_code is '机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.msgno is '报文参考号';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.zyed_flag is '占用额度标识 0是占用额度,1非占用额度';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0jtpmisqryfxsatqquota.etl_timestamp is 'ETL处理时间戳';
