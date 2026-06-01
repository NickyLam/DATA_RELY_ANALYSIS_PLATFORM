/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhd_divide_house_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhd_divide_house_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhd_divide_house_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_divide_house_info(
    serialno varchar2(64) -- 流水号
    ,duebillno varchar2(64) -- 信贷借据号
    ,productid varchar2(16) -- 产品
    ,currency varchar2(3) -- 币种
    ,contractno varchar2(64) -- 合同号
    ,putoutorgid varchar2(64) -- 贷款网点
    ,ysxflag varchar2(10) -- 预收息标识
    ,status varchar2(10) -- 贷款状态
    ,startdate varchar2(10) -- 起息日
    ,jxflag varchar2(10) -- 计息标识
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,classifyresult varchar2(2) -- 五级分类
    ,putoutdate varchar2(10) -- 贷款发放日期
    ,actualputoutsum number(24,6) -- 实际发放金额
    ,businesssum number(24,6) -- 贷款金额
    ,maturitydate varchar2(10) -- 贷款到期日期
    ,normalrate number(26,8) -- 正常利率
    ,overduerate number(26,8) -- 逾期利率
    ,compoundrate number(26,8) -- 复利利率
    ,contractsum number(24,6) -- 合同金额
    ,isgtgsh varchar2(10) -- 是否个体工商户
    ,enterprisesize varchar2(10) -- 企业规模
    ,baserate number(26,8) -- 基准利率
    ,industrytype varchar2(10) -- 国民经济部门类型
    ,yearbasedays varchar2(10) -- 年基准天数
    ,customertype varchar2(10) -- 客户类型
    ,accountstatus varchar2(10) -- 核算状态
    ,prioverdays varchar2(10) -- 本金逾期天数
    ,intoverdays varchar2(10) -- 利息逾期天数
    ,czflag varchar2(10) -- 冲正标识
    ,czdate varchar2(10) -- 冲正日期
    ,settledate varchar2(10) -- 结清日期
    ,termtimes varchar2(10) -- 当前期次
    ,unmatpriamt number(24,6) -- 未到期本金
    ,overpriamt number(24,6) -- 逾期本金
    ,interest number(24,6) -- 利息
    ,definterest number(24,6) -- 罚息
    ,overint number(24,6) -- 逾期利息
    ,compint number(24,6) -- 复利
    ,overdefint number(24,6) -- 逾期罚息
    ,defintcomp number(24,6) -- 罚息的复利
    ,overcomp number(24,6) -- 逾期复利
    ,frontcollintamt number(24,6) -- 前收息金额
    ,settlechangeint number(24,6) -- 已结转利息
    ,settlechangedef number(24,6) -- 已结转罚息
    ,settlechangecomp number(24,6) -- 已结转复息
    ,merchantname varchar2(200) -- 商户名称
    ,busilicenname varchar2(200) -- 营业执照名称
    ,migttype varchar2(10) -- 交易标志
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,nextdate varchar2(10) -- 下一结息日
    ,hxduebillno varchar2(30) -- 核心借据号
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
grant select on ${iol_schema}.icms_lhd_divide_house_info to ${iml_schema};
grant select on ${iol_schema}.icms_lhd_divide_house_info to ${icl_schema};
grant select on ${iol_schema}.icms_lhd_divide_house_info to ${idl_schema};
grant select on ${iol_schema}.icms_lhd_divide_house_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhd_divide_house_info is '信贷供分户信息文件临时表';
comment on column ${iol_schema}.icms_lhd_divide_house_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lhd_divide_house_info.duebillno is '信贷借据号';
comment on column ${iol_schema}.icms_lhd_divide_house_info.productid is '产品';
comment on column ${iol_schema}.icms_lhd_divide_house_info.currency is '币种';
comment on column ${iol_schema}.icms_lhd_divide_house_info.contractno is '合同号';
comment on column ${iol_schema}.icms_lhd_divide_house_info.putoutorgid is '贷款网点';
comment on column ${iol_schema}.icms_lhd_divide_house_info.ysxflag is '预收息标识';
comment on column ${iol_schema}.icms_lhd_divide_house_info.status is '贷款状态';
comment on column ${iol_schema}.icms_lhd_divide_house_info.startdate is '起息日';
comment on column ${iol_schema}.icms_lhd_divide_house_info.jxflag is '计息标识';
comment on column ${iol_schema}.icms_lhd_divide_house_info.customerid is '客户号';
comment on column ${iol_schema}.icms_lhd_divide_house_info.customername is '客户名称';
comment on column ${iol_schema}.icms_lhd_divide_house_info.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_lhd_divide_house_info.putoutdate is '贷款发放日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.actualputoutsum is '实际发放金额';
comment on column ${iol_schema}.icms_lhd_divide_house_info.businesssum is '贷款金额';
comment on column ${iol_schema}.icms_lhd_divide_house_info.maturitydate is '贷款到期日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.normalrate is '正常利率';
comment on column ${iol_schema}.icms_lhd_divide_house_info.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lhd_divide_house_info.compoundrate is '复利利率';
comment on column ${iol_schema}.icms_lhd_divide_house_info.contractsum is '合同金额';
comment on column ${iol_schema}.icms_lhd_divide_house_info.isgtgsh is '是否个体工商户';
comment on column ${iol_schema}.icms_lhd_divide_house_info.enterprisesize is '企业规模';
comment on column ${iol_schema}.icms_lhd_divide_house_info.baserate is '基准利率';
comment on column ${iol_schema}.icms_lhd_divide_house_info.industrytype is '国民经济部门类型';
comment on column ${iol_schema}.icms_lhd_divide_house_info.yearbasedays is '年基准天数';
comment on column ${iol_schema}.icms_lhd_divide_house_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_lhd_divide_house_info.accountstatus is '核算状态';
comment on column ${iol_schema}.icms_lhd_divide_house_info.prioverdays is '本金逾期天数';
comment on column ${iol_schema}.icms_lhd_divide_house_info.intoverdays is '利息逾期天数';
comment on column ${iol_schema}.icms_lhd_divide_house_info.czflag is '冲正标识';
comment on column ${iol_schema}.icms_lhd_divide_house_info.czdate is '冲正日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.settledate is '结清日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.termtimes is '当前期次';
comment on column ${iol_schema}.icms_lhd_divide_house_info.unmatpriamt is '未到期本金';
comment on column ${iol_schema}.icms_lhd_divide_house_info.overpriamt is '逾期本金';
comment on column ${iol_schema}.icms_lhd_divide_house_info.interest is '利息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.definterest is '罚息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.overint is '逾期利息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.compint is '复利';
comment on column ${iol_schema}.icms_lhd_divide_house_info.overdefint is '逾期罚息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.defintcomp is '罚息的复利';
comment on column ${iol_schema}.icms_lhd_divide_house_info.overcomp is '逾期复利';
comment on column ${iol_schema}.icms_lhd_divide_house_info.frontcollintamt is '前收息金额';
comment on column ${iol_schema}.icms_lhd_divide_house_info.settlechangeint is '已结转利息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.settlechangedef is '已结转罚息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.settlechangecomp is '已结转复息';
comment on column ${iol_schema}.icms_lhd_divide_house_info.merchantname is '商户名称';
comment on column ${iol_schema}.icms_lhd_divide_house_info.busilicenname is '营业执照名称';
comment on column ${iol_schema}.icms_lhd_divide_house_info.migttype is '交易标志';
comment on column ${iol_schema}.icms_lhd_divide_house_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhd_divide_house_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhd_divide_house_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhd_divide_house_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhd_divide_house_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.nextdate is '下一结息日';
comment on column ${iol_schema}.icms_lhd_divide_house_info.hxduebillno is '核心借据号';
comment on column ${iol_schema}.icms_lhd_divide_house_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhd_divide_house_info.etl_timestamp is 'ETL处理时间戳';
