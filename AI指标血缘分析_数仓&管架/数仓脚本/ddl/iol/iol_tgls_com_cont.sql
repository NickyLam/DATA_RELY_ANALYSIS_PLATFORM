/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_cont
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_cont
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_cont purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_cont(
    contid varchar2(60) -- 合同编号
    ,occubr varchar2(12) -- 发生机构编号
    ,signbr varchar2(12) -- 签约机构编号
    ,othena varchar2(80) -- 对方名称
    ,contst varchar2(2) -- 合同类型（01-权利，许可证照，02-营业账簿-其他账簿，03-财产保险合同，04-借款合同，05-技术合同，06-财产租赁合同，07-加工承揽合同，08-仓储保管合同，09-产权转移书据）
    ,contti varchar2(500) -- 合同标题
    ,conttx varchar2(4000) -- 合同内容
    ,begndt varchar2(8) -- 合同生效日
    ,endddt varchar2(8) -- 合同到期日
    ,freest varchar2(1) -- 免税标识：0，不免税1，免税
    ,paidst varchar2(1) -- 是否已计提：0，未计提1，已计提
    ,conamt number(21,2) -- 合同金额
    ,sourst varchar2(1) -- 合同信息来源：0，手工系统录入1，系统导入
    ,smrytx varchar2(2000) -- 备注
    ,signdt varchar2(8) -- 合同签约日期
    ,crcycd varchar2(3) -- 币种代码
    ,creadt date -- 合同录入vat系统时间
    ,stacid number(9) -- 帐套id
    ,taxdate varchar2(8) -- 计提日期
    ,vatxrt number(8,3) -- 计提税率/单价
    ,taxbam number(21,2) -- 计提税额
    ,claimid varchar2(50) -- 报销单号
    ,acctbr varchar2(12) -- 账务机构编号
    ,paydt varchar2(8) -- 付款日期
    ,attra2 varchar2(150) -- 企业规模
    ,attra7 varchar2(3) -- 国民经济部门类型
    ,systid varchar2(30) -- 系统标识
    ,conmac number(21,2) -- 金额/数量
    ,wtrelo varchar2(1) -- 是否循环贷(y/n/h),与智能报销系统无关h表示不涉及
    ,salprd varchar2(32) -- 可售产品
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_com_cont to ${iml_schema};
grant select on ${iol_schema}.tgls_com_cont to ${icl_schema};
grant select on ${iol_schema}.tgls_com_cont to ${idl_schema};
grant select on ${iol_schema}.tgls_com_cont to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_cont is '印花税合同信息';
comment on column ${iol_schema}.tgls_com_cont.contid is '合同编号';
comment on column ${iol_schema}.tgls_com_cont.occubr is '发生机构编号';
comment on column ${iol_schema}.tgls_com_cont.signbr is '签约机构编号';
comment on column ${iol_schema}.tgls_com_cont.othena is '对方名称';
comment on column ${iol_schema}.tgls_com_cont.contst is '合同类型（01-权利，许可证照，02-营业账簿-其他账簿，03-财产保险合同，04-借款合同，05-技术合同，06-财产租赁合同，07-加工承揽合同，08-仓储保管合同，09-产权转移书据）';
comment on column ${iol_schema}.tgls_com_cont.contti is '合同标题';
comment on column ${iol_schema}.tgls_com_cont.conttx is '合同内容';
comment on column ${iol_schema}.tgls_com_cont.begndt is '合同生效日';
comment on column ${iol_schema}.tgls_com_cont.endddt is '合同到期日';
comment on column ${iol_schema}.tgls_com_cont.freest is '免税标识：0，不免税1，免税';
comment on column ${iol_schema}.tgls_com_cont.paidst is '是否已计提：0，未计提1，已计提';
comment on column ${iol_schema}.tgls_com_cont.conamt is '合同金额';
comment on column ${iol_schema}.tgls_com_cont.sourst is '合同信息来源：0，手工系统录入1，系统导入';
comment on column ${iol_schema}.tgls_com_cont.smrytx is '备注';
comment on column ${iol_schema}.tgls_com_cont.signdt is '合同签约日期';
comment on column ${iol_schema}.tgls_com_cont.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_com_cont.creadt is '合同录入vat系统时间';
comment on column ${iol_schema}.tgls_com_cont.stacid is '帐套id';
comment on column ${iol_schema}.tgls_com_cont.taxdate is '计提日期';
comment on column ${iol_schema}.tgls_com_cont.vatxrt is '计提税率/单价';
comment on column ${iol_schema}.tgls_com_cont.taxbam is '计提税额';
comment on column ${iol_schema}.tgls_com_cont.claimid is '报销单号';
comment on column ${iol_schema}.tgls_com_cont.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_com_cont.paydt is '付款日期';
comment on column ${iol_schema}.tgls_com_cont.attra2 is '企业规模';
comment on column ${iol_schema}.tgls_com_cont.attra7 is '国民经济部门类型';
comment on column ${iol_schema}.tgls_com_cont.systid is '系统标识';
comment on column ${iol_schema}.tgls_com_cont.conmac is '金额/数量';
comment on column ${iol_schema}.tgls_com_cont.wtrelo is '是否循环贷(y/n/h),与智能报销系统无关h表示不涉及';
comment on column ${iol_schema}.tgls_com_cont.salprd is '可售产品';
comment on column ${iol_schema}.tgls_com_cont.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_com_cont.etl_timestamp is 'ETL处理时间戳';
