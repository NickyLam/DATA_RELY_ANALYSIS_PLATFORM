/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t3a_tsdt_n_hst
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.amls_t3a_tsdt_n_hst_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t3a_tsdt_n_hst
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t3a_tsdt_n_hst_op purge;
drop table ${iol_schema}.amls_t3a_tsdt_n_hst_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3a_tsdt_n_hst_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t3a_tsdt_n_hst where 0=1;

create table ${iol_schema}.amls_t3a_tsdt_n_hst_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t3a_tsdt_n_hst where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t3a_tsdt_n_hst_cl(
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t3a_tsdt_n_hst_op(
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rpt_id, o.rpt_id) as rpt_id -- 报告编号
    ,nvl(n.stat_dt, o.stat_dt) as stat_dt -- 数据日期
    ,nvl(n.cbif_seq, o.cbif_seq) as cbif_seq -- 客户序号
    ,nvl(n.crcd, o.crcd) as crcd -- 大额交易特征代码
    ,nvl(n.tsdt_seq, o.tsdt_seq) as tsdt_seq -- 交易序号
    ,nvl(n.atif_seq, o.atif_seq) as atif_seq -- 账户序号
    ,nvl(n.htcr_seq, o.htcr_seq) as htcr_seq -- 特征序号
    ,nvl(n.finc, o.finc) as finc -- 金融机构网点代码
    ,nvl(n.rlfc, o.rlfc) as rlfc -- 金融机构与客户的关系
    ,nvl(n.tbnm, o.tbnm) as tbnm -- 交易代办人姓名
    ,nvl(n.tbit, o.tbit) as tbit -- 交易代办人身份证件/证明文件类型
    ,nvl(n.tb_oitp, o.tb_oitp) as tb_oitp -- 其他身份证件/证明文件类型
    ,nvl(n.tbid, o.tbid) as tbid -- 交易代办人身份证件/证明文件号码
    ,nvl(n.tbnt, o.tbnt) as tbnt -- 交易代办人国籍
    ,nvl(n.tstm, o.tstm) as tstm -- 交易时间
    ,nvl(n.trcd, o.trcd) as trcd -- 交易发生地
    ,nvl(n.ticd, o.ticd) as ticd -- 业务标识号
    ,nvl(n.rpmt, o.rpmt) as rpmt -- 收付款方匹配号类型
    ,nvl(n.rpmn, o.rpmn) as rpmn -- 收付款方匹配号
    ,nvl(n.tstp, o.tstp) as tstp -- 交易方式
    ,nvl(n.octt, o.octt) as octt -- 非柜台交易方式
    ,nvl(n.ooct, o.ooct) as ooct -- 其他非柜台交易方式
    ,nvl(n.ocec, o.ocec) as ocec -- 非柜台交易方式的设备代码
    ,nvl(n.bptc, o.bptc) as bptc -- 银行与支付机构之间的业务交易编码
    ,nvl(n.tsct, o.tsct) as tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
    ,nvl(n.tsdr, o.tsdr) as tsdr -- 资金收付标志
    ,nvl(n.crpp, o.crpp) as crpp -- 资金用途
    ,nvl(n.crtp, o.crtp) as crtp -- 交易币种
    ,nvl(n.crat, o.crat) as crat -- 交易金额
    ,nvl(n.cfin, o.cfin) as cfin -- 对方金融机构网点名称
    ,nvl(n.cfct, o.cfct) as cfct -- 对方金融机构网点代码类型
    ,nvl(n.cfic, o.cfic) as cfic -- 对方金融机构网点代码
    ,nvl(n.cfrc, o.cfrc) as cfrc -- 对方金融机构网点行政区划代码
    ,nvl(n.tcnm, o.tcnm) as tcnm -- 交易对手姓名/名称
    ,nvl(n.tcit, o.tcit) as tcit -- 交易对手身份证件/证明文件类型
    ,nvl(n.tc_oitp, o.tc_oitp) as tc_oitp -- 其他身份证件/证明文件类型
    ,nvl(n.tcid, o.tcid) as tcid -- 交易对手身份证件/证明文件号码
    ,nvl(n.tcat, o.tcat) as tcat -- 交易对手账户类型
    ,nvl(n.tcac, o.tcac) as tcac -- 交易对手账号
    ,nvl(n.rotf1, o.rotf1) as rotf1 -- 交易信息备注1
    ,nvl(n.rotf2, o.rotf2) as rotf2 -- 交易信息备注2
    ,nvl(n.bh_valid, o.bh_valid) as bh_valid -- 大额验证（参见[字典:AML0041]）
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型（参见[字典:AML0030]）
    ,nvl(n.tr_dt, o.tr_dt) as tr_dt -- 交易日期
    ,nvl(n.tr_org_id, o.tr_org_id) as tr_org_id -- 交易机构
    ,nvl(n.is_cash, o.is_cash) as is_cash -- 现转标志（参见[字典:AML0034]）
    ,nvl(n.is_local_curr, o.is_local_curr) as is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,nvl(n.tr_amt, o.tr_amt) as tr_amt -- 原币交易金额
    ,nvl(n.debit_credit, o.debit_credit) as debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账号
    ,nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主客户账号
    ,nvl(n.card_no, o.card_no) as card_no -- 银行卡卡号
    ,nvl(n.rpdt, o.rpdt) as rpdt -- 报告生成日期
    ,nvl(n.err_type, o.err_type) as err_type -- 错误类型
    ,nvl(n.pbc_rcpt_tm, o.pbc_rcpt_tm) as pbc_rcpt_tm -- 人行回执时间
    ,nvl(n.crmb, o.crmb) as crmb -- 交易金额（折人民币）
    ,nvl(n.cusd, o.cusd) as cusd -- 交易金额（折美元）
    ,nvl(n.ccif_seq, o.ccif_seq) as ccif_seq -- 交易客户序号
    ,case when
            n.rpt_id is null
            and n.cbif_seq is null
            and n.crcd is null
            and n.tsdt_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rpt_id is null
            and n.cbif_seq is null
            and n.crcd is null
            and n.tsdt_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rpt_id is null
            and n.cbif_seq is null
            and n.crcd is null
            and n.tsdt_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t3a_tsdt_n_hst_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t3a_tsdt_n_hst where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rpt_id = n.rpt_id
            and o.cbif_seq = n.cbif_seq
            and o.crcd = n.crcd
            and o.tsdt_seq = n.tsdt_seq
where (
        o.rpt_id is null
        and o.cbif_seq is null
        and o.crcd is null
        and o.tsdt_seq is null
    )
    or (
        n.rpt_id is null
        and n.cbif_seq is null
        and n.crcd is null
        and n.tsdt_seq is null
    )
    or (
        o.stat_dt <> n.stat_dt
        or o.atif_seq <> n.atif_seq
        or o.htcr_seq <> n.htcr_seq
        or o.finc <> n.finc
        or o.rlfc <> n.rlfc
        or o.tbnm <> n.tbnm
        or o.tbit <> n.tbit
        or o.tb_oitp <> n.tb_oitp
        or o.tbid <> n.tbid
        or o.tbnt <> n.tbnt
        or o.tstm <> n.tstm
        or o.trcd <> n.trcd
        or o.ticd <> n.ticd
        or o.rpmt <> n.rpmt
        or o.rpmn <> n.rpmn
        or o.tstp <> n.tstp
        or o.octt <> n.octt
        or o.ooct <> n.ooct
        or o.ocec <> n.ocec
        or o.bptc <> n.bptc
        or o.tsct <> n.tsct
        or o.tsdr <> n.tsdr
        or o.crpp <> n.crpp
        or o.crtp <> n.crtp
        or o.crat <> n.crat
        or o.cfin <> n.cfin
        or o.cfct <> n.cfct
        or o.cfic <> n.cfic
        or o.cfrc <> n.cfrc
        or o.tcnm <> n.tcnm
        or o.tcit <> n.tcit
        or o.tc_oitp <> n.tc_oitp
        or o.tcid <> n.tcid
        or o.tcat <> n.tcat
        or o.tcac <> n.tcac
        or o.rotf1 <> n.rotf1
        or o.rotf2 <> n.rotf2
        or o.bh_valid <> n.bh_valid
        or o.cust_id <> n.cust_id
        or o.cust_type <> n.cust_type
        or o.tr_dt <> n.tr_dt
        or o.tr_org_id <> n.tr_org_id
        or o.is_cash <> n.is_cash
        or o.is_local_curr <> n.is_local_curr
        or o.tr_amt <> n.tr_amt
        or o.debit_credit <> n.debit_credit
        or o.acct_id <> n.acct_id
        or o.main_acct_id <> n.main_acct_id
        or o.card_no <> n.card_no
        or o.rpdt <> n.rpdt
        or o.err_type <> n.err_type
        or o.pbc_rcpt_tm <> n.pbc_rcpt_tm
        or o.crmb <> n.crmb
        or o.cusd <> n.cusd
        or o.ccif_seq <> n.ccif_seq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t3a_tsdt_n_hst_cl(
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t3a_tsdt_n_hst_op(
            rpt_id -- 报告编号
            ,stat_dt -- 数据日期
            ,cbif_seq -- 客户序号
            ,crcd -- 大额交易特征代码
            ,tsdt_seq -- 交易序号
            ,atif_seq -- 账户序号
            ,htcr_seq -- 特征序号
            ,finc -- 金融机构网点代码
            ,rlfc -- 金融机构与客户的关系
            ,tbnm -- 交易代办人姓名
            ,tbit -- 交易代办人身份证件/证明文件类型
            ,tb_oitp -- 其他身份证件/证明文件类型
            ,tbid -- 交易代办人身份证件/证明文件号码
            ,tbnt -- 交易代办人国籍
            ,tstm -- 交易时间
            ,trcd -- 交易发生地
            ,ticd -- 业务标识号
            ,rpmt -- 收付款方匹配号类型
            ,rpmn -- 收付款方匹配号
            ,tstp -- 交易方式
            ,octt -- 非柜台交易方式
            ,ooct -- 其他非柜台交易方式
            ,ocec -- 非柜台交易方式的设备代码
            ,bptc -- 银行与支付机构之间的业务交易编码
            ,tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
            ,tsdr -- 资金收付标志
            ,crpp -- 资金用途
            ,crtp -- 交易币种
            ,crat -- 交易金额
            ,cfin -- 对方金融机构网点名称
            ,cfct -- 对方金融机构网点代码类型
            ,cfic -- 对方金融机构网点代码
            ,cfrc -- 对方金融机构网点行政区划代码
            ,tcnm -- 交易对手姓名/名称
            ,tcit -- 交易对手身份证件/证明文件类型
            ,tc_oitp -- 其他身份证件/证明文件类型
            ,tcid -- 交易对手身份证件/证明文件号码
            ,tcat -- 交易对手账户类型
            ,tcac -- 交易对手账号
            ,rotf1 -- 交易信息备注1
            ,rotf2 -- 交易信息备注2
            ,bh_valid -- 大额验证（参见[字典:AML0041]）
            ,cust_id -- 客户编号
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_dt -- 交易日期
            ,tr_org_id -- 交易机构
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,tr_amt -- 原币交易金额
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,acct_id -- 账号
            ,main_acct_id -- 主客户账号
            ,card_no -- 银行卡卡号
            ,rpdt -- 报告生成日期
            ,err_type -- 错误类型
            ,pbc_rcpt_tm -- 人行回执时间
            ,crmb -- 交易金额（折人民币）
            ,cusd -- 交易金额（折美元）
            ,ccif_seq -- 交易客户序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rpt_id -- 报告编号
    ,o.stat_dt -- 数据日期
    ,o.cbif_seq -- 客户序号
    ,o.crcd -- 大额交易特征代码
    ,o.tsdt_seq -- 交易序号
    ,o.atif_seq -- 账户序号
    ,o.htcr_seq -- 特征序号
    ,o.finc -- 金融机构网点代码
    ,o.rlfc -- 金融机构与客户的关系
    ,o.tbnm -- 交易代办人姓名
    ,o.tbit -- 交易代办人身份证件/证明文件类型
    ,o.tb_oitp -- 其他身份证件/证明文件类型
    ,o.tbid -- 交易代办人身份证件/证明文件号码
    ,o.tbnt -- 交易代办人国籍
    ,o.tstm -- 交易时间
    ,o.trcd -- 交易发生地
    ,o.ticd -- 业务标识号
    ,o.rpmt -- 收付款方匹配号类型
    ,o.rpmn -- 收付款方匹配号
    ,o.tstp -- 交易方式
    ,o.octt -- 非柜台交易方式
    ,o.ooct -- 其他非柜台交易方式
    ,o.ocec -- 非柜台交易方式的设备代码
    ,o.bptc -- 银行与支付机构之间的业务交易编码
    ,o.tsct -- 涉外收支交易分类与代码(参见表t1p_tsct)
    ,o.tsdr -- 资金收付标志
    ,o.crpp -- 资金用途
    ,o.crtp -- 交易币种
    ,o.crat -- 交易金额
    ,o.cfin -- 对方金融机构网点名称
    ,o.cfct -- 对方金融机构网点代码类型
    ,o.cfic -- 对方金融机构网点代码
    ,o.cfrc -- 对方金融机构网点行政区划代码
    ,o.tcnm -- 交易对手姓名/名称
    ,o.tcit -- 交易对手身份证件/证明文件类型
    ,o.tc_oitp -- 其他身份证件/证明文件类型
    ,o.tcid -- 交易对手身份证件/证明文件号码
    ,o.tcat -- 交易对手账户类型
    ,o.tcac -- 交易对手账号
    ,o.rotf1 -- 交易信息备注1
    ,o.rotf2 -- 交易信息备注2
    ,o.bh_valid -- 大额验证（参见[字典:AML0041]）
    ,o.cust_id -- 客户编号
    ,o.cust_type -- 客户类型（参见[字典:AML0030]）
    ,o.tr_dt -- 交易日期
    ,o.tr_org_id -- 交易机构
    ,o.is_cash -- 现转标志（参见[字典:AML0034]）
    ,o.is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,o.tr_amt -- 原币交易金额
    ,o.debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,o.acct_id -- 账号
    ,o.main_acct_id -- 主客户账号
    ,o.card_no -- 银行卡卡号
    ,o.rpdt -- 报告生成日期
    ,o.err_type -- 错误类型
    ,o.pbc_rcpt_tm -- 人行回执时间
    ,o.crmb -- 交易金额（折人民币）
    ,o.cusd -- 交易金额（折美元）
    ,o.ccif_seq -- 交易客户序号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amls_t3a_tsdt_n_hst_bk o
    left join ${iol_schema}.amls_t3a_tsdt_n_hst_op n
        on
            o.rpt_id = n.rpt_id
            and o.cbif_seq = n.cbif_seq
            and o.crcd = n.crcd
            and o.tsdt_seq = n.tsdt_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t3a_tsdt_n_hst_cl d
        on
            o.rpt_id = d.rpt_id
            and o.cbif_seq = d.cbif_seq
            and o.crcd = d.crcd
            and o.tsdt_seq = d.tsdt_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t3a_tsdt_n_hst;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t3a_tsdt_n_hst') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t3a_tsdt_n_hst drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t3a_tsdt_n_hst add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t3a_tsdt_n_hst exchange partition p_${batch_date} with table ${iol_schema}.amls_t3a_tsdt_n_hst_cl;
alter table ${iol_schema}.amls_t3a_tsdt_n_hst exchange partition p_20991231 with table ${iol_schema}.amls_t3a_tsdt_n_hst_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t3a_tsdt_n_hst to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t3a_tsdt_n_hst_op purge;
drop table ${iol_schema}.amls_t3a_tsdt_n_hst_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t3a_tsdt_n_hst_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t3a_tsdt_n_hst',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
