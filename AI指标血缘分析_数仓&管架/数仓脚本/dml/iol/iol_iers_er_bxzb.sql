/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_er_bxzb
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
create table ${iol_schema}.iers_er_bxzb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_er_bxzb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_er_bxzb_op purge;
drop table ${iol_schema}.iers_er_bxzb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_er_bxzb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_er_bxzb where 0=1;

create table ${iol_schema}.iers_er_bxzb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_er_bxzb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_er_bxzb_cl(
            approver -- 审批人
            ,bbhl -- 本币汇率
            ,bbje -- 报销本币金额
            ,busitype -- 业务类型
            ,bzbm -- 币种
            ,cashitem -- 现金流量项目
            ,cashproj -- 资金计划项目
            ,center_dept -- 归口管理部门
            ,checktype -- 票据类型
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款原币金额
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,deptid -- 
            ,deptid_v -- 
            ,djbh -- 单据编号
            ,djdl -- 单据大类
            ,djlxbm -- 单据类型编码
            ,djrq -- 单据日期
            ,djzt -- 单据状态
            ,dr -- 删除标志
            ,dwbm -- 原报销人单位
            ,dwbm_v -- 报销人单位
            ,dztz_batch -- 到账通知交易流水号
            ,dztz_billid -- 到账通知主键
            ,dztz_billno -- 到账通知单据号
            ,fjzs -- 附件张数
            ,fkyhzh -- 单位银行账户
            ,flexible_flag -- 项目-是否柔性控制
            ,freecust -- 散户
            ,fydeptid -- 原费用承担部门
            ,fydeptid_v -- 费用承担部门
            ,fydwbm -- 原费用承担单位
            ,fydwbm_v -- 费用承担单位
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局报销本币金额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团报销本币金额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款原币金额
            ,imag_status -- 影像状态
            ,ischeck -- 是否限额
            ,iscostshare -- 是否分摊
            ,iscusupplier -- 对公支付
            ,isexpamt -- 是否待摊
            ,isexpedited -- 紧急
            ,ismashare -- 申请单是否分摊
            ,isneedimag -- 需要影像扫描
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,jsh -- 结算号
            ,jsr -- 签字人
            ,jsrq -- 签字日期
            ,kjnd -- 会计年度
            ,kjqj -- 会计期间
            ,mngaccid -- 管理账户
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最终修改人
            ,officialprintdate -- 正式打印日期
            ,officialprintuser -- 正式打印人
            ,operator -- 录入人
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paydate -- 支付日期
            ,payflag -- 支付状态
            ,payman -- 支付人
            ,paytarget -- 收款对象
            ,pjh -- 票据号
            ,pk_billtype -- 单据类型
            ,pk_brand -- 品牌
            ,pk_campaign -- 营销活动
            ,pk_cashaccount -- 现金帐户
            ,pk_checkele -- 核算要素
            ,pk_contractno -- 付款合同
            ,pk_fiorg -- 财务组织
            ,pk_group -- 集团
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_matters -- 营销事项
            ,pk_org -- 原报销单位
            ,pk_org_v -- 报销单位
            ,pk_payorg -- 原支付组织
            ,pk_payorg_v -- 支付组织
            ,pk_pcorg -- 原利润中心
            ,pk_pcorg_v -- 利润中心
            ,pk_proline -- 产品线
            ,pk_resacostcenter -- 成本中心
            ,pk_tradetypeid -- 交易类型
            ,projecttask -- 项目任务
            ,qcbz -- 期初标志
            ,qzzt -- 清帐状态
            ,receiver -- 收款人
            ,red_status -- 红冲标志
            ,redbillpk -- 红冲单据主键
            ,reimrule -- 报销标准
            ,saga_btxid -- 当前分支id
            ,saga_frozen -- 是否冻结
            ,saga_gtxid -- 全局事务id
            ,saga_status -- 事务状态
            ,shrq -- 审批时间
            ,skyhzh -- 个人银行账户
            ,spzt -- 审批状态
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srcsystem -- 来源系统
            ,srctype -- 来源类型
            ,start_period -- 开始摊销期间
            ,sxbz -- 生效状态
            ,szxmid -- 收支项目
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tbb_period -- 预算占用期间
            ,tni_amount -- 不含税金额
            ,total -- 合计金额
            ,total_period -- 总摊销期
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,vouchertag -- 凭证标志
            ,ybje -- 报销原币金额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付原币金额
            ,zy -- 事由
            ,zyx1 -- 自定义项1
            ,zyx10 -- 自定义项10
            ,zyx11 -- 自定义项11
            ,zyx12 -- 自定义项12
            ,zyx13 -- 自定义项13
            ,zyx14 -- 自定义项14
            ,zyx15 -- 自定义项15
            ,zyx16 -- 自定义项16
            ,zyx17 -- 自定义项17
            ,zyx18 -- 自定义项18
            ,zyx19 -- 自定义项19
            ,zyx2 -- 自定义项2
            ,zyx20 -- 自定义项20
            ,zyx21 -- 自定义项21
            ,zyx22 -- 自定义项22
            ,zyx23 -- 自定义项23
            ,zyx24 -- 自定义项24
            ,zyx25 -- 自定义项25
            ,zyx26 -- 自定义项26
            ,zyx27 -- 自定义项27
            ,zyx28 -- 自定义项28
            ,zyx29 -- 自定义项29
            ,zyx3 -- 自定义项3
            ,zyx30 -- 自定义项30
            ,zyx31 -- 自定义项31
            ,zyx32 -- 自定义项32
            ,zyx33 -- 自定义项33
            ,zyx34 -- 自定义项34
            ,zyx35 -- 自定义项35
            ,zyx36 -- 自定义项36
            ,zyx37 -- 自定义项37
            ,zyx38 -- 自定义项38
            ,zyx39 -- 自定义项39
            ,zyx4 -- 自定义项4
            ,zyx40 -- 自定义项40
            ,zyx41 -- 自定义项41
            ,zyx42 -- 自定义项42
            ,zyx43 -- 自定义项43
            ,zyx44 -- 自定义项44
            ,zyx45 -- 自定义项45
            ,zyx46 -- 自定义项46
            ,zyx47 -- 自定义项47
            ,zyx48 -- 自定义项48
            ,zyx49 -- 自定义项49
            ,zyx5 -- 自定义项5
            ,zyx50 -- 自定义项50
            ,zyx51 -- 自定义项51
            ,zyx52 -- 自定义项52
            ,zyx53 -- 自定义项53
            ,zyx54 -- 自定义项54
            ,zyx55 -- 自定义项55
            ,zyx56 -- 自定义项56
            ,zyx57 -- 自定义项57
            ,zyx58 -- 自定义项58
            ,zyx59 -- 自定义项59
            ,zyx6 -- 自定义项6
            ,zyx60 -- 自定义项60
            ,zyx61 -- 自定义项61
            ,zyx62 -- 自定义项62
            ,zyx63 -- 自定义项63
            ,zyx64 -- 自定义项64
            ,zyx65 -- 自定义项65
            ,zyx66 -- 自定义项66
            ,zyx67 -- 自定义项67
            ,zyx68 -- 自定义项68
            ,zyx69 -- 自定义项69
            ,zyx7 -- 自定义项7
            ,zyx70 -- 自定义项70
            ,zyx71 -- 自定义项71
            ,zyx72 -- 自定义项72
            ,zyx73 -- 自定义项73
            ,zyx74 -- 自定义项74
            ,zyx75 -- 自定义项75
            ,zyx76 -- 自定义项76
            ,zyx77 -- 自定义项77
            ,zyx78 -- 自定义项78
            ,zyx79 -- 自定义项79
            ,zyx8 -- 自定义项8
            ,zyx80 -- 自定义项80
            ,zyx9 -- 自定义项9
            ,sdsj -- 收单时间
            ,sdyfzt -- 收单验符状态
            ,rulecheckmsg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_er_bxzb_op(
            approver -- 审批人
            ,bbhl -- 本币汇率
            ,bbje -- 报销本币金额
            ,busitype -- 业务类型
            ,bzbm -- 币种
            ,cashitem -- 现金流量项目
            ,cashproj -- 资金计划项目
            ,center_dept -- 归口管理部门
            ,checktype -- 票据类型
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款原币金额
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,deptid -- 
            ,deptid_v -- 
            ,djbh -- 单据编号
            ,djdl -- 单据大类
            ,djlxbm -- 单据类型编码
            ,djrq -- 单据日期
            ,djzt -- 单据状态
            ,dr -- 删除标志
            ,dwbm -- 原报销人单位
            ,dwbm_v -- 报销人单位
            ,dztz_batch -- 到账通知交易流水号
            ,dztz_billid -- 到账通知主键
            ,dztz_billno -- 到账通知单据号
            ,fjzs -- 附件张数
            ,fkyhzh -- 单位银行账户
            ,flexible_flag -- 项目-是否柔性控制
            ,freecust -- 散户
            ,fydeptid -- 原费用承担部门
            ,fydeptid_v -- 费用承担部门
            ,fydwbm -- 原费用承担单位
            ,fydwbm_v -- 费用承担单位
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局报销本币金额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团报销本币金额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款原币金额
            ,imag_status -- 影像状态
            ,ischeck -- 是否限额
            ,iscostshare -- 是否分摊
            ,iscusupplier -- 对公支付
            ,isexpamt -- 是否待摊
            ,isexpedited -- 紧急
            ,ismashare -- 申请单是否分摊
            ,isneedimag -- 需要影像扫描
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,jsh -- 结算号
            ,jsr -- 签字人
            ,jsrq -- 签字日期
            ,kjnd -- 会计年度
            ,kjqj -- 会计期间
            ,mngaccid -- 管理账户
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最终修改人
            ,officialprintdate -- 正式打印日期
            ,officialprintuser -- 正式打印人
            ,operator -- 录入人
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paydate -- 支付日期
            ,payflag -- 支付状态
            ,payman -- 支付人
            ,paytarget -- 收款对象
            ,pjh -- 票据号
            ,pk_billtype -- 单据类型
            ,pk_brand -- 品牌
            ,pk_campaign -- 营销活动
            ,pk_cashaccount -- 现金帐户
            ,pk_checkele -- 核算要素
            ,pk_contractno -- 付款合同
            ,pk_fiorg -- 财务组织
            ,pk_group -- 集团
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_matters -- 营销事项
            ,pk_org -- 原报销单位
            ,pk_org_v -- 报销单位
            ,pk_payorg -- 原支付组织
            ,pk_payorg_v -- 支付组织
            ,pk_pcorg -- 原利润中心
            ,pk_pcorg_v -- 利润中心
            ,pk_proline -- 产品线
            ,pk_resacostcenter -- 成本中心
            ,pk_tradetypeid -- 交易类型
            ,projecttask -- 项目任务
            ,qcbz -- 期初标志
            ,qzzt -- 清帐状态
            ,receiver -- 收款人
            ,red_status -- 红冲标志
            ,redbillpk -- 红冲单据主键
            ,reimrule -- 报销标准
            ,saga_btxid -- 当前分支id
            ,saga_frozen -- 是否冻结
            ,saga_gtxid -- 全局事务id
            ,saga_status -- 事务状态
            ,shrq -- 审批时间
            ,skyhzh -- 个人银行账户
            ,spzt -- 审批状态
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srcsystem -- 来源系统
            ,srctype -- 来源类型
            ,start_period -- 开始摊销期间
            ,sxbz -- 生效状态
            ,szxmid -- 收支项目
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tbb_period -- 预算占用期间
            ,tni_amount -- 不含税金额
            ,total -- 合计金额
            ,total_period -- 总摊销期
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,vouchertag -- 凭证标志
            ,ybje -- 报销原币金额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付原币金额
            ,zy -- 事由
            ,zyx1 -- 自定义项1
            ,zyx10 -- 自定义项10
            ,zyx11 -- 自定义项11
            ,zyx12 -- 自定义项12
            ,zyx13 -- 自定义项13
            ,zyx14 -- 自定义项14
            ,zyx15 -- 自定义项15
            ,zyx16 -- 自定义项16
            ,zyx17 -- 自定义项17
            ,zyx18 -- 自定义项18
            ,zyx19 -- 自定义项19
            ,zyx2 -- 自定义项2
            ,zyx20 -- 自定义项20
            ,zyx21 -- 自定义项21
            ,zyx22 -- 自定义项22
            ,zyx23 -- 自定义项23
            ,zyx24 -- 自定义项24
            ,zyx25 -- 自定义项25
            ,zyx26 -- 自定义项26
            ,zyx27 -- 自定义项27
            ,zyx28 -- 自定义项28
            ,zyx29 -- 自定义项29
            ,zyx3 -- 自定义项3
            ,zyx30 -- 自定义项30
            ,zyx31 -- 自定义项31
            ,zyx32 -- 自定义项32
            ,zyx33 -- 自定义项33
            ,zyx34 -- 自定义项34
            ,zyx35 -- 自定义项35
            ,zyx36 -- 自定义项36
            ,zyx37 -- 自定义项37
            ,zyx38 -- 自定义项38
            ,zyx39 -- 自定义项39
            ,zyx4 -- 自定义项4
            ,zyx40 -- 自定义项40
            ,zyx41 -- 自定义项41
            ,zyx42 -- 自定义项42
            ,zyx43 -- 自定义项43
            ,zyx44 -- 自定义项44
            ,zyx45 -- 自定义项45
            ,zyx46 -- 自定义项46
            ,zyx47 -- 自定义项47
            ,zyx48 -- 自定义项48
            ,zyx49 -- 自定义项49
            ,zyx5 -- 自定义项5
            ,zyx50 -- 自定义项50
            ,zyx51 -- 自定义项51
            ,zyx52 -- 自定义项52
            ,zyx53 -- 自定义项53
            ,zyx54 -- 自定义项54
            ,zyx55 -- 自定义项55
            ,zyx56 -- 自定义项56
            ,zyx57 -- 自定义项57
            ,zyx58 -- 自定义项58
            ,zyx59 -- 自定义项59
            ,zyx6 -- 自定义项6
            ,zyx60 -- 自定义项60
            ,zyx61 -- 自定义项61
            ,zyx62 -- 自定义项62
            ,zyx63 -- 自定义项63
            ,zyx64 -- 自定义项64
            ,zyx65 -- 自定义项65
            ,zyx66 -- 自定义项66
            ,zyx67 -- 自定义项67
            ,zyx68 -- 自定义项68
            ,zyx69 -- 自定义项69
            ,zyx7 -- 自定义项7
            ,zyx70 -- 自定义项70
            ,zyx71 -- 自定义项71
            ,zyx72 -- 自定义项72
            ,zyx73 -- 自定义项73
            ,zyx74 -- 自定义项74
            ,zyx75 -- 自定义项75
            ,zyx76 -- 自定义项76
            ,zyx77 -- 自定义项77
            ,zyx78 -- 自定义项78
            ,zyx79 -- 自定义项79
            ,zyx8 -- 自定义项8
            ,zyx80 -- 自定义项80
            ,zyx9 -- 自定义项9
            ,sdsj -- 收单时间
            ,sdyfzt -- 收单验符状态
            ,rulecheckmsg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.approver, o.approver) as approver -- 审批人
    ,nvl(n.bbhl, o.bbhl) as bbhl -- 本币汇率
    ,nvl(n.bbje, o.bbje) as bbje -- 报销本币金额
    ,nvl(n.busitype, o.busitype) as busitype -- 业务类型
    ,nvl(n.bzbm, o.bzbm) as bzbm -- 币种
    ,nvl(n.cashitem, o.cashitem) as cashitem -- 现金流量项目
    ,nvl(n.cashproj, o.cashproj) as cashproj -- 资金计划项目
    ,nvl(n.center_dept, o.center_dept) as center_dept -- 归口管理部门
    ,nvl(n.checktype, o.checktype) as checktype -- 票据类型
    ,nvl(n.cjkbbje, o.cjkbbje) as cjkbbje -- 冲借款本币金额
    ,nvl(n.cjkybje, o.cjkybje) as cjkybje -- 冲借款原币金额
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.custaccount, o.custaccount) as custaccount -- 客商银行账户
    ,nvl(n.customer, o.customer) as customer -- 客户
    ,nvl(n.deptid, o.deptid) as deptid -- 
    ,nvl(n.deptid_v, o.deptid_v) as deptid_v -- 
    ,nvl(n.djbh, o.djbh) as djbh -- 单据编号
    ,nvl(n.djdl, o.djdl) as djdl -- 单据大类
    ,nvl(n.djlxbm, o.djlxbm) as djlxbm -- 单据类型编码
    ,nvl(n.djrq, o.djrq) as djrq -- 单据日期
    ,nvl(n.djzt, o.djzt) as djzt -- 单据状态
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.dwbm, o.dwbm) as dwbm -- 原报销人单位
    ,nvl(n.dwbm_v, o.dwbm_v) as dwbm_v -- 报销人单位
    ,nvl(n.dztz_batch, o.dztz_batch) as dztz_batch -- 到账通知交易流水号
    ,nvl(n.dztz_billid, o.dztz_billid) as dztz_billid -- 到账通知主键
    ,nvl(n.dztz_billno, o.dztz_billno) as dztz_billno -- 到账通知单据号
    ,nvl(n.fjzs, o.fjzs) as fjzs -- 附件张数
    ,nvl(n.fkyhzh, o.fkyhzh) as fkyhzh -- 单位银行账户
    ,nvl(n.flexible_flag, o.flexible_flag) as flexible_flag -- 项目-是否柔性控制
    ,nvl(n.freecust, o.freecust) as freecust -- 散户
    ,nvl(n.fydeptid, o.fydeptid) as fydeptid -- 原费用承担部门
    ,nvl(n.fydeptid_v, o.fydeptid_v) as fydeptid_v -- 费用承担部门
    ,nvl(n.fydwbm, o.fydwbm) as fydwbm -- 原费用承担单位
    ,nvl(n.fydwbm_v, o.fydwbm_v) as fydwbm_v -- 费用承担单位
    ,nvl(n.globalbbhl, o.globalbbhl) as globalbbhl -- 全局本币汇率
    ,nvl(n.globalbbje, o.globalbbje) as globalbbje -- 全局报销本币金额
    ,nvl(n.globalcjkbbje, o.globalcjkbbje) as globalcjkbbje -- 全局冲借款本币金额
    ,nvl(n.globalhkbbje, o.globalhkbbje) as globalhkbbje -- 全局还款本币金额
    ,nvl(n.globaltax_amount, o.globaltax_amount) as globaltax_amount -- 全局税金本币金额
    ,nvl(n.globaltni_amount, o.globaltni_amount) as globaltni_amount -- 全局不含税本币金额
    ,nvl(n.globalvat_amount, o.globalvat_amount) as globalvat_amount -- 全局含税本币金额
    ,nvl(n.globalzfbbje, o.globalzfbbje) as globalzfbbje -- 全局支付本币金额
    ,nvl(n.groupbbhl, o.groupbbhl) as groupbbhl -- 集团本币汇率
    ,nvl(n.groupbbje, o.groupbbje) as groupbbje -- 集团报销本币金额
    ,nvl(n.groupcjkbbje, o.groupcjkbbje) as groupcjkbbje -- 集团冲借款本币金额
    ,nvl(n.grouphkbbje, o.grouphkbbje) as grouphkbbje -- 集团还款本币金额
    ,nvl(n.grouptax_amount, o.grouptax_amount) as grouptax_amount -- 集团税金本币金额
    ,nvl(n.grouptni_amount, o.grouptni_amount) as grouptni_amount -- 集团不含税本币金额
    ,nvl(n.groupvat_amount, o.groupvat_amount) as groupvat_amount -- 集团含税本币金额
    ,nvl(n.groupzfbbje, o.groupzfbbje) as groupzfbbje -- 集团支付本币金额
    ,nvl(n.hbbm, o.hbbm) as hbbm -- 供应商
    ,nvl(n.hkbbje, o.hkbbje) as hkbbje -- 还款本币金额
    ,nvl(n.hkybje, o.hkybje) as hkybje -- 还款原币金额
    ,nvl(n.imag_status, o.imag_status) as imag_status -- 影像状态
    ,nvl(n.ischeck, o.ischeck) as ischeck -- 是否限额
    ,nvl(n.iscostshare, o.iscostshare) as iscostshare -- 是否分摊
    ,nvl(n.iscusupplier, o.iscusupplier) as iscusupplier -- 对公支付
    ,nvl(n.isexpamt, o.isexpamt) as isexpamt -- 是否待摊
    ,nvl(n.isexpedited, o.isexpedited) as isexpedited -- 紧急
    ,nvl(n.ismashare, o.ismashare) as ismashare -- 申请单是否分摊
    ,nvl(n.isneedimag, o.isneedimag) as isneedimag -- 需要影像扫描
    ,nvl(n.jkbxr, o.jkbxr) as jkbxr -- 报销人
    ,nvl(n.jobid, o.jobid) as jobid -- 项目
    ,nvl(n.jsfs, o.jsfs) as jsfs -- 结算方式
    ,nvl(n.jsh, o.jsh) as jsh -- 结算号
    ,nvl(n.jsr, o.jsr) as jsr -- 签字人
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 签字日期
    ,nvl(n.kjnd, o.kjnd) as kjnd -- 会计年度
    ,nvl(n.kjqj, o.kjqj) as kjqj -- 会计期间
    ,nvl(n.mngaccid, o.mngaccid) as mngaccid -- 管理账户
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最终修改人
    ,nvl(n.officialprintdate, o.officialprintdate) as officialprintdate -- 正式打印日期
    ,nvl(n.officialprintuser, o.officialprintuser) as officialprintuser -- 正式打印人
    ,nvl(n.operator, o.operator) as operator -- 录入人
    ,nvl(n.orgtax_amount, o.orgtax_amount) as orgtax_amount -- 税金组织本币金额
    ,nvl(n.orgtni_amount, o.orgtni_amount) as orgtni_amount -- 不含税组织本位币金额
    ,nvl(n.orgvat_amount, o.orgvat_amount) as orgvat_amount -- 含税组织本位币金额
    ,nvl(n.paydate, o.paydate) as paydate -- 支付日期
    ,nvl(n.payflag, o.payflag) as payflag -- 支付状态
    ,nvl(n.payman, o.payman) as payman -- 支付人
    ,nvl(n.paytarget, o.paytarget) as paytarget -- 收款对象
    ,nvl(n.pjh, o.pjh) as pjh -- 票据号
    ,nvl(n.pk_billtype, o.pk_billtype) as pk_billtype -- 单据类型
    ,nvl(n.pk_brand, o.pk_brand) as pk_brand -- 品牌
    ,nvl(n.pk_campaign, o.pk_campaign) as pk_campaign -- 营销活动
    ,nvl(n.pk_cashaccount, o.pk_cashaccount) as pk_cashaccount -- 现金帐户
    ,nvl(n.pk_checkele, o.pk_checkele) as pk_checkele -- 核算要素
    ,nvl(n.pk_contractno, o.pk_contractno) as pk_contractno -- 付款合同
    ,nvl(n.pk_fiorg, o.pk_fiorg) as pk_fiorg -- 财务组织
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_item, o.pk_item) as pk_item -- 费用申请单
    ,nvl(n.pk_jkbx, o.pk_jkbx) as pk_jkbx -- 报销单标识
    ,nvl(n.pk_matters, o.pk_matters) as pk_matters -- 营销事项
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 原报销单位
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 报销单位
    ,nvl(n.pk_payorg, o.pk_payorg) as pk_payorg -- 原支付组织
    ,nvl(n.pk_payorg_v, o.pk_payorg_v) as pk_payorg_v -- 支付组织
    ,nvl(n.pk_pcorg, o.pk_pcorg) as pk_pcorg -- 原利润中心
    ,nvl(n.pk_pcorg_v, o.pk_pcorg_v) as pk_pcorg_v -- 利润中心
    ,nvl(n.pk_proline, o.pk_proline) as pk_proline -- 产品线
    ,nvl(n.pk_resacostcenter, o.pk_resacostcenter) as pk_resacostcenter -- 成本中心
    ,nvl(n.pk_tradetypeid, o.pk_tradetypeid) as pk_tradetypeid -- 交易类型
    ,nvl(n.projecttask, o.projecttask) as projecttask -- 项目任务
    ,nvl(n.qcbz, o.qcbz) as qcbz -- 期初标志
    ,nvl(n.qzzt, o.qzzt) as qzzt -- 清帐状态
    ,nvl(n.receiver, o.receiver) as receiver -- 收款人
    ,nvl(n.red_status, o.red_status) as red_status -- 红冲标志
    ,nvl(n.redbillpk, o.redbillpk) as redbillpk -- 红冲单据主键
    ,nvl(n.reimrule, o.reimrule) as reimrule -- 报销标准
    ,nvl(n.saga_btxid, o.saga_btxid) as saga_btxid -- 当前分支id
    ,nvl(n.saga_frozen, o.saga_frozen) as saga_frozen -- 是否冻结
    ,nvl(n.saga_gtxid, o.saga_gtxid) as saga_gtxid -- 全局事务id
    ,nvl(n.saga_status, o.saga_status) as saga_status -- 事务状态
    ,nvl(n.shrq, o.shrq) as shrq -- 审批时间
    ,nvl(n.skyhzh, o.skyhzh) as skyhzh -- 个人银行账户
    ,nvl(n.spzt, o.spzt) as spzt -- 审批状态
    ,nvl(n.src_ybz_id, o.src_ybz_id) as src_ybz_id -- 友报账id
    ,nvl(n.srcbilltype, o.srcbilltype) as srcbilltype -- 来源单据类型
    ,nvl(n.srcsystem, o.srcsystem) as srcsystem -- 来源系统
    ,nvl(n.srctype, o.srctype) as srctype -- 来源类型
    ,nvl(n.start_period, o.start_period) as start_period -- 开始摊销期间
    ,nvl(n.sxbz, o.sxbz) as sxbz -- 生效状态
    ,nvl(n.szxmid, o.szxmid) as szxmid -- 收支项目
    ,nvl(n.tax_amount, o.tax_amount) as tax_amount -- 税金金额
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.tbb_period, o.tbb_period) as tbb_period -- 预算占用期间
    ,nvl(n.tni_amount, o.tni_amount) as tni_amount -- 不含税金额
    ,nvl(n.total, o.total) as total -- 合计金额
    ,nvl(n.total_period, o.total_period) as total_period -- 总摊销期
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.vat_amount, o.vat_amount) as vat_amount -- 含税金额
    ,nvl(n.vouchertag, o.vouchertag) as vouchertag -- 凭证标志
    ,nvl(n.ybje, o.ybje) as ybje -- 报销原币金额
    ,nvl(n.zfbbje, o.zfbbje) as zfbbje -- 支付本币金额
    ,nvl(n.zfybje, o.zfybje) as zfybje -- 支付原币金额
    ,nvl(n.zy, o.zy) as zy -- 事由
    ,nvl(n.zyx1, o.zyx1) as zyx1 -- 自定义项1
    ,nvl(n.zyx10, o.zyx10) as zyx10 -- 自定义项10
    ,nvl(n.zyx11, o.zyx11) as zyx11 -- 自定义项11
    ,nvl(n.zyx12, o.zyx12) as zyx12 -- 自定义项12
    ,nvl(n.zyx13, o.zyx13) as zyx13 -- 自定义项13
    ,nvl(n.zyx14, o.zyx14) as zyx14 -- 自定义项14
    ,nvl(n.zyx15, o.zyx15) as zyx15 -- 自定义项15
    ,nvl(n.zyx16, o.zyx16) as zyx16 -- 自定义项16
    ,nvl(n.zyx17, o.zyx17) as zyx17 -- 自定义项17
    ,nvl(n.zyx18, o.zyx18) as zyx18 -- 自定义项18
    ,nvl(n.zyx19, o.zyx19) as zyx19 -- 自定义项19
    ,nvl(n.zyx2, o.zyx2) as zyx2 -- 自定义项2
    ,nvl(n.zyx20, o.zyx20) as zyx20 -- 自定义项20
    ,nvl(n.zyx21, o.zyx21) as zyx21 -- 自定义项21
    ,nvl(n.zyx22, o.zyx22) as zyx22 -- 自定义项22
    ,nvl(n.zyx23, o.zyx23) as zyx23 -- 自定义项23
    ,nvl(n.zyx24, o.zyx24) as zyx24 -- 自定义项24
    ,nvl(n.zyx25, o.zyx25) as zyx25 -- 自定义项25
    ,nvl(n.zyx26, o.zyx26) as zyx26 -- 自定义项26
    ,nvl(n.zyx27, o.zyx27) as zyx27 -- 自定义项27
    ,nvl(n.zyx28, o.zyx28) as zyx28 -- 自定义项28
    ,nvl(n.zyx29, o.zyx29) as zyx29 -- 自定义项29
    ,nvl(n.zyx3, o.zyx3) as zyx3 -- 自定义项3
    ,nvl(n.zyx30, o.zyx30) as zyx30 -- 自定义项30
    ,nvl(n.zyx31, o.zyx31) as zyx31 -- 自定义项31
    ,nvl(n.zyx32, o.zyx32) as zyx32 -- 自定义项32
    ,nvl(n.zyx33, o.zyx33) as zyx33 -- 自定义项33
    ,nvl(n.zyx34, o.zyx34) as zyx34 -- 自定义项34
    ,nvl(n.zyx35, o.zyx35) as zyx35 -- 自定义项35
    ,nvl(n.zyx36, o.zyx36) as zyx36 -- 自定义项36
    ,nvl(n.zyx37, o.zyx37) as zyx37 -- 自定义项37
    ,nvl(n.zyx38, o.zyx38) as zyx38 -- 自定义项38
    ,nvl(n.zyx39, o.zyx39) as zyx39 -- 自定义项39
    ,nvl(n.zyx4, o.zyx4) as zyx4 -- 自定义项4
    ,nvl(n.zyx40, o.zyx40) as zyx40 -- 自定义项40
    ,nvl(n.zyx41, o.zyx41) as zyx41 -- 自定义项41
    ,nvl(n.zyx42, o.zyx42) as zyx42 -- 自定义项42
    ,nvl(n.zyx43, o.zyx43) as zyx43 -- 自定义项43
    ,nvl(n.zyx44, o.zyx44) as zyx44 -- 自定义项44
    ,nvl(n.zyx45, o.zyx45) as zyx45 -- 自定义项45
    ,nvl(n.zyx46, o.zyx46) as zyx46 -- 自定义项46
    ,nvl(n.zyx47, o.zyx47) as zyx47 -- 自定义项47
    ,nvl(n.zyx48, o.zyx48) as zyx48 -- 自定义项48
    ,nvl(n.zyx49, o.zyx49) as zyx49 -- 自定义项49
    ,nvl(n.zyx5, o.zyx5) as zyx5 -- 自定义项5
    ,nvl(n.zyx50, o.zyx50) as zyx50 -- 自定义项50
    ,nvl(n.zyx51, o.zyx51) as zyx51 -- 自定义项51
    ,nvl(n.zyx52, o.zyx52) as zyx52 -- 自定义项52
    ,nvl(n.zyx53, o.zyx53) as zyx53 -- 自定义项53
    ,nvl(n.zyx54, o.zyx54) as zyx54 -- 自定义项54
    ,nvl(n.zyx55, o.zyx55) as zyx55 -- 自定义项55
    ,nvl(n.zyx56, o.zyx56) as zyx56 -- 自定义项56
    ,nvl(n.zyx57, o.zyx57) as zyx57 -- 自定义项57
    ,nvl(n.zyx58, o.zyx58) as zyx58 -- 自定义项58
    ,nvl(n.zyx59, o.zyx59) as zyx59 -- 自定义项59
    ,nvl(n.zyx6, o.zyx6) as zyx6 -- 自定义项6
    ,nvl(n.zyx60, o.zyx60) as zyx60 -- 自定义项60
    ,nvl(n.zyx61, o.zyx61) as zyx61 -- 自定义项61
    ,nvl(n.zyx62, o.zyx62) as zyx62 -- 自定义项62
    ,nvl(n.zyx63, o.zyx63) as zyx63 -- 自定义项63
    ,nvl(n.zyx64, o.zyx64) as zyx64 -- 自定义项64
    ,nvl(n.zyx65, o.zyx65) as zyx65 -- 自定义项65
    ,nvl(n.zyx66, o.zyx66) as zyx66 -- 自定义项66
    ,nvl(n.zyx67, o.zyx67) as zyx67 -- 自定义项67
    ,nvl(n.zyx68, o.zyx68) as zyx68 -- 自定义项68
    ,nvl(n.zyx69, o.zyx69) as zyx69 -- 自定义项69
    ,nvl(n.zyx7, o.zyx7) as zyx7 -- 自定义项7
    ,nvl(n.zyx70, o.zyx70) as zyx70 -- 自定义项70
    ,nvl(n.zyx71, o.zyx71) as zyx71 -- 自定义项71
    ,nvl(n.zyx72, o.zyx72) as zyx72 -- 自定义项72
    ,nvl(n.zyx73, o.zyx73) as zyx73 -- 自定义项73
    ,nvl(n.zyx74, o.zyx74) as zyx74 -- 自定义项74
    ,nvl(n.zyx75, o.zyx75) as zyx75 -- 自定义项75
    ,nvl(n.zyx76, o.zyx76) as zyx76 -- 自定义项76
    ,nvl(n.zyx77, o.zyx77) as zyx77 -- 自定义项77
    ,nvl(n.zyx78, o.zyx78) as zyx78 -- 自定义项78
    ,nvl(n.zyx79, o.zyx79) as zyx79 -- 自定义项79
    ,nvl(n.zyx8, o.zyx8) as zyx8 -- 自定义项8
    ,nvl(n.zyx80, o.zyx80) as zyx80 -- 自定义项80
    ,nvl(n.zyx9, o.zyx9) as zyx9 -- 自定义项9
    ,nvl(n.sdsj, o.sdsj) as sdsj -- 收单时间
    ,nvl(n.sdyfzt, o.sdyfzt) as sdyfzt -- 收单验符状态
    ,nvl(n.rulecheckmsg, o.rulecheckmsg) as rulecheckmsg -- 
    ,case when
            n.pk_jkbx is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_jkbx is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_jkbx is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_er_bxzb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_er_bxzb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_jkbx = n.pk_jkbx
where (
        o.pk_jkbx is null
    )
    or (
        n.pk_jkbx is null
    )
    or (
        o.approver <> n.approver
        or o.bbhl <> n.bbhl
        or o.bbje <> n.bbje
        or o.busitype <> n.busitype
        or o.bzbm <> n.bzbm
        or o.cashitem <> n.cashitem
        or o.cashproj <> n.cashproj
        or o.center_dept <> n.center_dept
        or o.checktype <> n.checktype
        or o.cjkbbje <> n.cjkbbje
        or o.cjkybje <> n.cjkybje
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.custaccount <> n.custaccount
        or o.customer <> n.customer
        or o.deptid <> n.deptid
        or o.deptid_v <> n.deptid_v
        or o.djbh <> n.djbh
        or o.djdl <> n.djdl
        or o.djlxbm <> n.djlxbm
        or o.djrq <> n.djrq
        or o.djzt <> n.djzt
        or o.dr <> n.dr
        or o.dwbm <> n.dwbm
        or o.dwbm_v <> n.dwbm_v
        or o.dztz_batch <> n.dztz_batch
        or o.dztz_billid <> n.dztz_billid
        or o.dztz_billno <> n.dztz_billno
        or o.fjzs <> n.fjzs
        or o.fkyhzh <> n.fkyhzh
        or o.flexible_flag <> n.flexible_flag
        or o.freecust <> n.freecust
        or o.fydeptid <> n.fydeptid
        or o.fydeptid_v <> n.fydeptid_v
        or o.fydwbm <> n.fydwbm
        or o.fydwbm_v <> n.fydwbm_v
        or o.globalbbhl <> n.globalbbhl
        or o.globalbbje <> n.globalbbje
        or o.globalcjkbbje <> n.globalcjkbbje
        or o.globalhkbbje <> n.globalhkbbje
        or o.globaltax_amount <> n.globaltax_amount
        or o.globaltni_amount <> n.globaltni_amount
        or o.globalvat_amount <> n.globalvat_amount
        or o.globalzfbbje <> n.globalzfbbje
        or o.groupbbhl <> n.groupbbhl
        or o.groupbbje <> n.groupbbje
        or o.groupcjkbbje <> n.groupcjkbbje
        or o.grouphkbbje <> n.grouphkbbje
        or o.grouptax_amount <> n.grouptax_amount
        or o.grouptni_amount <> n.grouptni_amount
        or o.groupvat_amount <> n.groupvat_amount
        or o.groupzfbbje <> n.groupzfbbje
        or o.hbbm <> n.hbbm
        or o.hkbbje <> n.hkbbje
        or o.hkybje <> n.hkybje
        or o.imag_status <> n.imag_status
        or o.ischeck <> n.ischeck
        or o.iscostshare <> n.iscostshare
        or o.iscusupplier <> n.iscusupplier
        or o.isexpamt <> n.isexpamt
        or o.isexpedited <> n.isexpedited
        or o.ismashare <> n.ismashare
        or o.isneedimag <> n.isneedimag
        or o.jkbxr <> n.jkbxr
        or o.jobid <> n.jobid
        or o.jsfs <> n.jsfs
        or o.jsh <> n.jsh
        or o.jsr <> n.jsr
        or o.jsrq <> n.jsrq
        or o.kjnd <> n.kjnd
        or o.kjqj <> n.kjqj
        or o.mngaccid <> n.mngaccid
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.officialprintdate <> n.officialprintdate
        or o.officialprintuser <> n.officialprintuser
        or o.operator <> n.operator
        or o.orgtax_amount <> n.orgtax_amount
        or o.orgtni_amount <> n.orgtni_amount
        or o.orgvat_amount <> n.orgvat_amount
        or o.paydate <> n.paydate
        or o.payflag <> n.payflag
        or o.payman <> n.payman
        or o.paytarget <> n.paytarget
        or o.pjh <> n.pjh
        or o.pk_billtype <> n.pk_billtype
        or o.pk_brand <> n.pk_brand
        or o.pk_campaign <> n.pk_campaign
        or o.pk_cashaccount <> n.pk_cashaccount
        or o.pk_checkele <> n.pk_checkele
        or o.pk_contractno <> n.pk_contractno
        or o.pk_fiorg <> n.pk_fiorg
        or o.pk_group <> n.pk_group
        or o.pk_item <> n.pk_item
        or o.pk_matters <> n.pk_matters
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_payorg <> n.pk_payorg
        or o.pk_payorg_v <> n.pk_payorg_v
        or o.pk_pcorg <> n.pk_pcorg
        or o.pk_pcorg_v <> n.pk_pcorg_v
        or o.pk_proline <> n.pk_proline
        or o.pk_resacostcenter <> n.pk_resacostcenter
        or o.pk_tradetypeid <> n.pk_tradetypeid
        or o.projecttask <> n.projecttask
        or o.qcbz <> n.qcbz
        or o.qzzt <> n.qzzt
        or o.receiver <> n.receiver
        or o.red_status <> n.red_status
        or o.redbillpk <> n.redbillpk
        or o.reimrule <> n.reimrule
        or o.saga_btxid <> n.saga_btxid
        or o.saga_frozen <> n.saga_frozen
        or o.saga_gtxid <> n.saga_gtxid
        or o.saga_status <> n.saga_status
        or o.shrq <> n.shrq
        or o.skyhzh <> n.skyhzh
        or o.spzt <> n.spzt
        or o.src_ybz_id <> n.src_ybz_id
        or o.srcbilltype <> n.srcbilltype
        or o.srcsystem <> n.srcsystem
        or o.srctype <> n.srctype
        or o.start_period <> n.start_period
        or o.sxbz <> n.sxbz
        or o.szxmid <> n.szxmid
        or o.tax_amount <> n.tax_amount
        or o.tax_rate <> n.tax_rate
        or o.tbb_period <> n.tbb_period
        or o.tni_amount <> n.tni_amount
        or o.total <> n.total
        or o.total_period <> n.total_period
        or o.ts <> n.ts
        or o.vat_amount <> n.vat_amount
        or o.vouchertag <> n.vouchertag
        or o.ybje <> n.ybje
        or o.zfbbje <> n.zfbbje
        or o.zfybje <> n.zfybje
        or o.zy <> n.zy
        or o.zyx1 <> n.zyx1
        or o.zyx10 <> n.zyx10
        or o.zyx11 <> n.zyx11
        or o.zyx12 <> n.zyx12
        or o.zyx13 <> n.zyx13
        or o.zyx14 <> n.zyx14
        or o.zyx15 <> n.zyx15
        or o.zyx16 <> n.zyx16
        or o.zyx17 <> n.zyx17
        or o.zyx18 <> n.zyx18
        or o.zyx19 <> n.zyx19
        or o.zyx2 <> n.zyx2
        or o.zyx20 <> n.zyx20
        or o.zyx21 <> n.zyx21
        or o.zyx22 <> n.zyx22
        or o.zyx23 <> n.zyx23
        or o.zyx24 <> n.zyx24
        or o.zyx25 <> n.zyx25
        or o.zyx26 <> n.zyx26
        or o.zyx27 <> n.zyx27
        or o.zyx28 <> n.zyx28
        or o.zyx29 <> n.zyx29
        or o.zyx3 <> n.zyx3
        or o.zyx30 <> n.zyx30
        or o.zyx31 <> n.zyx31
        or o.zyx32 <> n.zyx32
        or o.zyx33 <> n.zyx33
        or o.zyx34 <> n.zyx34
        or o.zyx35 <> n.zyx35
        or o.zyx36 <> n.zyx36
        or o.zyx37 <> n.zyx37
        or o.zyx38 <> n.zyx38
        or o.zyx39 <> n.zyx39
        or o.zyx4 <> n.zyx4
        or o.zyx40 <> n.zyx40
        or o.zyx41 <> n.zyx41
        or o.zyx42 <> n.zyx42
        or o.zyx43 <> n.zyx43
        or o.zyx44 <> n.zyx44
        or o.zyx45 <> n.zyx45
        or o.zyx46 <> n.zyx46
        or o.zyx47 <> n.zyx47
        or o.zyx48 <> n.zyx48
        or o.zyx49 <> n.zyx49
        or o.zyx5 <> n.zyx5
        or o.zyx50 <> n.zyx50
        or o.zyx51 <> n.zyx51
        or o.zyx52 <> n.zyx52
        or o.zyx53 <> n.zyx53
        or o.zyx54 <> n.zyx54
        or o.zyx55 <> n.zyx55
        or o.zyx56 <> n.zyx56
        or o.zyx57 <> n.zyx57
        or o.zyx58 <> n.zyx58
        or o.zyx59 <> n.zyx59
        or o.zyx6 <> n.zyx6
        or o.zyx60 <> n.zyx60
        or o.zyx61 <> n.zyx61
        or o.zyx62 <> n.zyx62
        or o.zyx63 <> n.zyx63
        or o.zyx64 <> n.zyx64
        or o.zyx65 <> n.zyx65
        or o.zyx66 <> n.zyx66
        or o.zyx67 <> n.zyx67
        or o.zyx68 <> n.zyx68
        or o.zyx69 <> n.zyx69
        or o.zyx7 <> n.zyx7
        or o.zyx70 <> n.zyx70
        or o.zyx71 <> n.zyx71
        or o.zyx72 <> n.zyx72
        or o.zyx73 <> n.zyx73
        or o.zyx74 <> n.zyx74
        or o.zyx75 <> n.zyx75
        or o.zyx76 <> n.zyx76
        or o.zyx77 <> n.zyx77
        or o.zyx78 <> n.zyx78
        or o.zyx79 <> n.zyx79
        or o.zyx8 <> n.zyx8
        or o.zyx80 <> n.zyx80
        or o.zyx9 <> n.zyx9
        or o.sdsj <> n.sdsj
        or o.sdyfzt <> n.sdyfzt
        or o.rulecheckmsg <> n.rulecheckmsg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_er_bxzb_cl(
            approver -- 审批人
            ,bbhl -- 本币汇率
            ,bbje -- 报销本币金额
            ,busitype -- 业务类型
            ,bzbm -- 币种
            ,cashitem -- 现金流量项目
            ,cashproj -- 资金计划项目
            ,center_dept -- 归口管理部门
            ,checktype -- 票据类型
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款原币金额
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,deptid -- 
            ,deptid_v -- 
            ,djbh -- 单据编号
            ,djdl -- 单据大类
            ,djlxbm -- 单据类型编码
            ,djrq -- 单据日期
            ,djzt -- 单据状态
            ,dr -- 删除标志
            ,dwbm -- 原报销人单位
            ,dwbm_v -- 报销人单位
            ,dztz_batch -- 到账通知交易流水号
            ,dztz_billid -- 到账通知主键
            ,dztz_billno -- 到账通知单据号
            ,fjzs -- 附件张数
            ,fkyhzh -- 单位银行账户
            ,flexible_flag -- 项目-是否柔性控制
            ,freecust -- 散户
            ,fydeptid -- 原费用承担部门
            ,fydeptid_v -- 费用承担部门
            ,fydwbm -- 原费用承担单位
            ,fydwbm_v -- 费用承担单位
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局报销本币金额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团报销本币金额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款原币金额
            ,imag_status -- 影像状态
            ,ischeck -- 是否限额
            ,iscostshare -- 是否分摊
            ,iscusupplier -- 对公支付
            ,isexpamt -- 是否待摊
            ,isexpedited -- 紧急
            ,ismashare -- 申请单是否分摊
            ,isneedimag -- 需要影像扫描
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,jsh -- 结算号
            ,jsr -- 签字人
            ,jsrq -- 签字日期
            ,kjnd -- 会计年度
            ,kjqj -- 会计期间
            ,mngaccid -- 管理账户
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最终修改人
            ,officialprintdate -- 正式打印日期
            ,officialprintuser -- 正式打印人
            ,operator -- 录入人
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paydate -- 支付日期
            ,payflag -- 支付状态
            ,payman -- 支付人
            ,paytarget -- 收款对象
            ,pjh -- 票据号
            ,pk_billtype -- 单据类型
            ,pk_brand -- 品牌
            ,pk_campaign -- 营销活动
            ,pk_cashaccount -- 现金帐户
            ,pk_checkele -- 核算要素
            ,pk_contractno -- 付款合同
            ,pk_fiorg -- 财务组织
            ,pk_group -- 集团
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_matters -- 营销事项
            ,pk_org -- 原报销单位
            ,pk_org_v -- 报销单位
            ,pk_payorg -- 原支付组织
            ,pk_payorg_v -- 支付组织
            ,pk_pcorg -- 原利润中心
            ,pk_pcorg_v -- 利润中心
            ,pk_proline -- 产品线
            ,pk_resacostcenter -- 成本中心
            ,pk_tradetypeid -- 交易类型
            ,projecttask -- 项目任务
            ,qcbz -- 期初标志
            ,qzzt -- 清帐状态
            ,receiver -- 收款人
            ,red_status -- 红冲标志
            ,redbillpk -- 红冲单据主键
            ,reimrule -- 报销标准
            ,saga_btxid -- 当前分支id
            ,saga_frozen -- 是否冻结
            ,saga_gtxid -- 全局事务id
            ,saga_status -- 事务状态
            ,shrq -- 审批时间
            ,skyhzh -- 个人银行账户
            ,spzt -- 审批状态
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srcsystem -- 来源系统
            ,srctype -- 来源类型
            ,start_period -- 开始摊销期间
            ,sxbz -- 生效状态
            ,szxmid -- 收支项目
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tbb_period -- 预算占用期间
            ,tni_amount -- 不含税金额
            ,total -- 合计金额
            ,total_period -- 总摊销期
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,vouchertag -- 凭证标志
            ,ybje -- 报销原币金额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付原币金额
            ,zy -- 事由
            ,zyx1 -- 自定义项1
            ,zyx10 -- 自定义项10
            ,zyx11 -- 自定义项11
            ,zyx12 -- 自定义项12
            ,zyx13 -- 自定义项13
            ,zyx14 -- 自定义项14
            ,zyx15 -- 自定义项15
            ,zyx16 -- 自定义项16
            ,zyx17 -- 自定义项17
            ,zyx18 -- 自定义项18
            ,zyx19 -- 自定义项19
            ,zyx2 -- 自定义项2
            ,zyx20 -- 自定义项20
            ,zyx21 -- 自定义项21
            ,zyx22 -- 自定义项22
            ,zyx23 -- 自定义项23
            ,zyx24 -- 自定义项24
            ,zyx25 -- 自定义项25
            ,zyx26 -- 自定义项26
            ,zyx27 -- 自定义项27
            ,zyx28 -- 自定义项28
            ,zyx29 -- 自定义项29
            ,zyx3 -- 自定义项3
            ,zyx30 -- 自定义项30
            ,zyx31 -- 自定义项31
            ,zyx32 -- 自定义项32
            ,zyx33 -- 自定义项33
            ,zyx34 -- 自定义项34
            ,zyx35 -- 自定义项35
            ,zyx36 -- 自定义项36
            ,zyx37 -- 自定义项37
            ,zyx38 -- 自定义项38
            ,zyx39 -- 自定义项39
            ,zyx4 -- 自定义项4
            ,zyx40 -- 自定义项40
            ,zyx41 -- 自定义项41
            ,zyx42 -- 自定义项42
            ,zyx43 -- 自定义项43
            ,zyx44 -- 自定义项44
            ,zyx45 -- 自定义项45
            ,zyx46 -- 自定义项46
            ,zyx47 -- 自定义项47
            ,zyx48 -- 自定义项48
            ,zyx49 -- 自定义项49
            ,zyx5 -- 自定义项5
            ,zyx50 -- 自定义项50
            ,zyx51 -- 自定义项51
            ,zyx52 -- 自定义项52
            ,zyx53 -- 自定义项53
            ,zyx54 -- 自定义项54
            ,zyx55 -- 自定义项55
            ,zyx56 -- 自定义项56
            ,zyx57 -- 自定义项57
            ,zyx58 -- 自定义项58
            ,zyx59 -- 自定义项59
            ,zyx6 -- 自定义项6
            ,zyx60 -- 自定义项60
            ,zyx61 -- 自定义项61
            ,zyx62 -- 自定义项62
            ,zyx63 -- 自定义项63
            ,zyx64 -- 自定义项64
            ,zyx65 -- 自定义项65
            ,zyx66 -- 自定义项66
            ,zyx67 -- 自定义项67
            ,zyx68 -- 自定义项68
            ,zyx69 -- 自定义项69
            ,zyx7 -- 自定义项7
            ,zyx70 -- 自定义项70
            ,zyx71 -- 自定义项71
            ,zyx72 -- 自定义项72
            ,zyx73 -- 自定义项73
            ,zyx74 -- 自定义项74
            ,zyx75 -- 自定义项75
            ,zyx76 -- 自定义项76
            ,zyx77 -- 自定义项77
            ,zyx78 -- 自定义项78
            ,zyx79 -- 自定义项79
            ,zyx8 -- 自定义项8
            ,zyx80 -- 自定义项80
            ,zyx9 -- 自定义项9
            ,sdsj -- 收单时间
            ,sdyfzt -- 收单验符状态
            ,rulecheckmsg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_er_bxzb_op(
            approver -- 审批人
            ,bbhl -- 本币汇率
            ,bbje -- 报销本币金额
            ,busitype -- 业务类型
            ,bzbm -- 币种
            ,cashitem -- 现金流量项目
            ,cashproj -- 资金计划项目
            ,center_dept -- 归口管理部门
            ,checktype -- 票据类型
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款原币金额
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,deptid -- 
            ,deptid_v -- 
            ,djbh -- 单据编号
            ,djdl -- 单据大类
            ,djlxbm -- 单据类型编码
            ,djrq -- 单据日期
            ,djzt -- 单据状态
            ,dr -- 删除标志
            ,dwbm -- 原报销人单位
            ,dwbm_v -- 报销人单位
            ,dztz_batch -- 到账通知交易流水号
            ,dztz_billid -- 到账通知主键
            ,dztz_billno -- 到账通知单据号
            ,fjzs -- 附件张数
            ,fkyhzh -- 单位银行账户
            ,flexible_flag -- 项目-是否柔性控制
            ,freecust -- 散户
            ,fydeptid -- 原费用承担部门
            ,fydeptid_v -- 费用承担部门
            ,fydwbm -- 原费用承担单位
            ,fydwbm_v -- 费用承担单位
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局报销本币金额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团报销本币金额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款原币金额
            ,imag_status -- 影像状态
            ,ischeck -- 是否限额
            ,iscostshare -- 是否分摊
            ,iscusupplier -- 对公支付
            ,isexpamt -- 是否待摊
            ,isexpedited -- 紧急
            ,ismashare -- 申请单是否分摊
            ,isneedimag -- 需要影像扫描
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,jsh -- 结算号
            ,jsr -- 签字人
            ,jsrq -- 签字日期
            ,kjnd -- 会计年度
            ,kjqj -- 会计期间
            ,mngaccid -- 管理账户
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最终修改人
            ,officialprintdate -- 正式打印日期
            ,officialprintuser -- 正式打印人
            ,operator -- 录入人
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paydate -- 支付日期
            ,payflag -- 支付状态
            ,payman -- 支付人
            ,paytarget -- 收款对象
            ,pjh -- 票据号
            ,pk_billtype -- 单据类型
            ,pk_brand -- 品牌
            ,pk_campaign -- 营销活动
            ,pk_cashaccount -- 现金帐户
            ,pk_checkele -- 核算要素
            ,pk_contractno -- 付款合同
            ,pk_fiorg -- 财务组织
            ,pk_group -- 集团
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_matters -- 营销事项
            ,pk_org -- 原报销单位
            ,pk_org_v -- 报销单位
            ,pk_payorg -- 原支付组织
            ,pk_payorg_v -- 支付组织
            ,pk_pcorg -- 原利润中心
            ,pk_pcorg_v -- 利润中心
            ,pk_proline -- 产品线
            ,pk_resacostcenter -- 成本中心
            ,pk_tradetypeid -- 交易类型
            ,projecttask -- 项目任务
            ,qcbz -- 期初标志
            ,qzzt -- 清帐状态
            ,receiver -- 收款人
            ,red_status -- 红冲标志
            ,redbillpk -- 红冲单据主键
            ,reimrule -- 报销标准
            ,saga_btxid -- 当前分支id
            ,saga_frozen -- 是否冻结
            ,saga_gtxid -- 全局事务id
            ,saga_status -- 事务状态
            ,shrq -- 审批时间
            ,skyhzh -- 个人银行账户
            ,spzt -- 审批状态
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srcsystem -- 来源系统
            ,srctype -- 来源类型
            ,start_period -- 开始摊销期间
            ,sxbz -- 生效状态
            ,szxmid -- 收支项目
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tbb_period -- 预算占用期间
            ,tni_amount -- 不含税金额
            ,total -- 合计金额
            ,total_period -- 总摊销期
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,vouchertag -- 凭证标志
            ,ybje -- 报销原币金额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付原币金额
            ,zy -- 事由
            ,zyx1 -- 自定义项1
            ,zyx10 -- 自定义项10
            ,zyx11 -- 自定义项11
            ,zyx12 -- 自定义项12
            ,zyx13 -- 自定义项13
            ,zyx14 -- 自定义项14
            ,zyx15 -- 自定义项15
            ,zyx16 -- 自定义项16
            ,zyx17 -- 自定义项17
            ,zyx18 -- 自定义项18
            ,zyx19 -- 自定义项19
            ,zyx2 -- 自定义项2
            ,zyx20 -- 自定义项20
            ,zyx21 -- 自定义项21
            ,zyx22 -- 自定义项22
            ,zyx23 -- 自定义项23
            ,zyx24 -- 自定义项24
            ,zyx25 -- 自定义项25
            ,zyx26 -- 自定义项26
            ,zyx27 -- 自定义项27
            ,zyx28 -- 自定义项28
            ,zyx29 -- 自定义项29
            ,zyx3 -- 自定义项3
            ,zyx30 -- 自定义项30
            ,zyx31 -- 自定义项31
            ,zyx32 -- 自定义项32
            ,zyx33 -- 自定义项33
            ,zyx34 -- 自定义项34
            ,zyx35 -- 自定义项35
            ,zyx36 -- 自定义项36
            ,zyx37 -- 自定义项37
            ,zyx38 -- 自定义项38
            ,zyx39 -- 自定义项39
            ,zyx4 -- 自定义项4
            ,zyx40 -- 自定义项40
            ,zyx41 -- 自定义项41
            ,zyx42 -- 自定义项42
            ,zyx43 -- 自定义项43
            ,zyx44 -- 自定义项44
            ,zyx45 -- 自定义项45
            ,zyx46 -- 自定义项46
            ,zyx47 -- 自定义项47
            ,zyx48 -- 自定义项48
            ,zyx49 -- 自定义项49
            ,zyx5 -- 自定义项5
            ,zyx50 -- 自定义项50
            ,zyx51 -- 自定义项51
            ,zyx52 -- 自定义项52
            ,zyx53 -- 自定义项53
            ,zyx54 -- 自定义项54
            ,zyx55 -- 自定义项55
            ,zyx56 -- 自定义项56
            ,zyx57 -- 自定义项57
            ,zyx58 -- 自定义项58
            ,zyx59 -- 自定义项59
            ,zyx6 -- 自定义项6
            ,zyx60 -- 自定义项60
            ,zyx61 -- 自定义项61
            ,zyx62 -- 自定义项62
            ,zyx63 -- 自定义项63
            ,zyx64 -- 自定义项64
            ,zyx65 -- 自定义项65
            ,zyx66 -- 自定义项66
            ,zyx67 -- 自定义项67
            ,zyx68 -- 自定义项68
            ,zyx69 -- 自定义项69
            ,zyx7 -- 自定义项7
            ,zyx70 -- 自定义项70
            ,zyx71 -- 自定义项71
            ,zyx72 -- 自定义项72
            ,zyx73 -- 自定义项73
            ,zyx74 -- 自定义项74
            ,zyx75 -- 自定义项75
            ,zyx76 -- 自定义项76
            ,zyx77 -- 自定义项77
            ,zyx78 -- 自定义项78
            ,zyx79 -- 自定义项79
            ,zyx8 -- 自定义项8
            ,zyx80 -- 自定义项80
            ,zyx9 -- 自定义项9
            ,sdsj -- 收单时间
            ,sdyfzt -- 收单验符状态
            ,rulecheckmsg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.approver -- 审批人
    ,o.bbhl -- 本币汇率
    ,o.bbje -- 报销本币金额
    ,o.busitype -- 业务类型
    ,o.bzbm -- 币种
    ,o.cashitem -- 现金流量项目
    ,o.cashproj -- 资金计划项目
    ,o.center_dept -- 归口管理部门
    ,o.checktype -- 票据类型
    ,o.cjkbbje -- 冲借款本币金额
    ,o.cjkybje -- 冲借款原币金额
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.custaccount -- 客商银行账户
    ,o.customer -- 客户
    ,o.deptid -- 
    ,o.deptid_v -- 
    ,o.djbh -- 单据编号
    ,o.djdl -- 单据大类
    ,o.djlxbm -- 单据类型编码
    ,o.djrq -- 单据日期
    ,o.djzt -- 单据状态
    ,o.dr -- 删除标志
    ,o.dwbm -- 原报销人单位
    ,o.dwbm_v -- 报销人单位
    ,o.dztz_batch -- 到账通知交易流水号
    ,o.dztz_billid -- 到账通知主键
    ,o.dztz_billno -- 到账通知单据号
    ,o.fjzs -- 附件张数
    ,o.fkyhzh -- 单位银行账户
    ,o.flexible_flag -- 项目-是否柔性控制
    ,o.freecust -- 散户
    ,o.fydeptid -- 原费用承担部门
    ,o.fydeptid_v -- 费用承担部门
    ,o.fydwbm -- 原费用承担单位
    ,o.fydwbm_v -- 费用承担单位
    ,o.globalbbhl -- 全局本币汇率
    ,o.globalbbje -- 全局报销本币金额
    ,o.globalcjkbbje -- 全局冲借款本币金额
    ,o.globalhkbbje -- 全局还款本币金额
    ,o.globaltax_amount -- 全局税金本币金额
    ,o.globaltni_amount -- 全局不含税本币金额
    ,o.globalvat_amount -- 全局含税本币金额
    ,o.globalzfbbje -- 全局支付本币金额
    ,o.groupbbhl -- 集团本币汇率
    ,o.groupbbje -- 集团报销本币金额
    ,o.groupcjkbbje -- 集团冲借款本币金额
    ,o.grouphkbbje -- 集团还款本币金额
    ,o.grouptax_amount -- 集团税金本币金额
    ,o.grouptni_amount -- 集团不含税本币金额
    ,o.groupvat_amount -- 集团含税本币金额
    ,o.groupzfbbje -- 集团支付本币金额
    ,o.hbbm -- 供应商
    ,o.hkbbje -- 还款本币金额
    ,o.hkybje -- 还款原币金额
    ,o.imag_status -- 影像状态
    ,o.ischeck -- 是否限额
    ,o.iscostshare -- 是否分摊
    ,o.iscusupplier -- 对公支付
    ,o.isexpamt -- 是否待摊
    ,o.isexpedited -- 紧急
    ,o.ismashare -- 申请单是否分摊
    ,o.isneedimag -- 需要影像扫描
    ,o.jkbxr -- 报销人
    ,o.jobid -- 项目
    ,o.jsfs -- 结算方式
    ,o.jsh -- 结算号
    ,o.jsr -- 签字人
    ,o.jsrq -- 签字日期
    ,o.kjnd -- 会计年度
    ,o.kjqj -- 会计期间
    ,o.mngaccid -- 管理账户
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最终修改人
    ,o.officialprintdate -- 正式打印日期
    ,o.officialprintuser -- 正式打印人
    ,o.operator -- 录入人
    ,o.orgtax_amount -- 税金组织本币金额
    ,o.orgtni_amount -- 不含税组织本位币金额
    ,o.orgvat_amount -- 含税组织本位币金额
    ,o.paydate -- 支付日期
    ,o.payflag -- 支付状态
    ,o.payman -- 支付人
    ,o.paytarget -- 收款对象
    ,o.pjh -- 票据号
    ,o.pk_billtype -- 单据类型
    ,o.pk_brand -- 品牌
    ,o.pk_campaign -- 营销活动
    ,o.pk_cashaccount -- 现金帐户
    ,o.pk_checkele -- 核算要素
    ,o.pk_contractno -- 付款合同
    ,o.pk_fiorg -- 财务组织
    ,o.pk_group -- 集团
    ,o.pk_item -- 费用申请单
    ,o.pk_jkbx -- 报销单标识
    ,o.pk_matters -- 营销事项
    ,o.pk_org -- 原报销单位
    ,o.pk_org_v -- 报销单位
    ,o.pk_payorg -- 原支付组织
    ,o.pk_payorg_v -- 支付组织
    ,o.pk_pcorg -- 原利润中心
    ,o.pk_pcorg_v -- 利润中心
    ,o.pk_proline -- 产品线
    ,o.pk_resacostcenter -- 成本中心
    ,o.pk_tradetypeid -- 交易类型
    ,o.projecttask -- 项目任务
    ,o.qcbz -- 期初标志
    ,o.qzzt -- 清帐状态
    ,o.receiver -- 收款人
    ,o.red_status -- 红冲标志
    ,o.redbillpk -- 红冲单据主键
    ,o.reimrule -- 报销标准
    ,o.saga_btxid -- 当前分支id
    ,o.saga_frozen -- 是否冻结
    ,o.saga_gtxid -- 全局事务id
    ,o.saga_status -- 事务状态
    ,o.shrq -- 审批时间
    ,o.skyhzh -- 个人银行账户
    ,o.spzt -- 审批状态
    ,o.src_ybz_id -- 友报账id
    ,o.srcbilltype -- 来源单据类型
    ,o.srcsystem -- 来源系统
    ,o.srctype -- 来源类型
    ,o.start_period -- 开始摊销期间
    ,o.sxbz -- 生效状态
    ,o.szxmid -- 收支项目
    ,o.tax_amount -- 税金金额
    ,o.tax_rate -- 税率
    ,o.tbb_period -- 预算占用期间
    ,o.tni_amount -- 不含税金额
    ,o.total -- 合计金额
    ,o.total_period -- 总摊销期
    ,o.ts -- 时间戳
    ,o.vat_amount -- 含税金额
    ,o.vouchertag -- 凭证标志
    ,o.ybje -- 报销原币金额
    ,o.zfbbje -- 支付本币金额
    ,o.zfybje -- 支付原币金额
    ,o.zy -- 事由
    ,o.zyx1 -- 自定义项1
    ,o.zyx10 -- 自定义项10
    ,o.zyx11 -- 自定义项11
    ,o.zyx12 -- 自定义项12
    ,o.zyx13 -- 自定义项13
    ,o.zyx14 -- 自定义项14
    ,o.zyx15 -- 自定义项15
    ,o.zyx16 -- 自定义项16
    ,o.zyx17 -- 自定义项17
    ,o.zyx18 -- 自定义项18
    ,o.zyx19 -- 自定义项19
    ,o.zyx2 -- 自定义项2
    ,o.zyx20 -- 自定义项20
    ,o.zyx21 -- 自定义项21
    ,o.zyx22 -- 自定义项22
    ,o.zyx23 -- 自定义项23
    ,o.zyx24 -- 自定义项24
    ,o.zyx25 -- 自定义项25
    ,o.zyx26 -- 自定义项26
    ,o.zyx27 -- 自定义项27
    ,o.zyx28 -- 自定义项28
    ,o.zyx29 -- 自定义项29
    ,o.zyx3 -- 自定义项3
    ,o.zyx30 -- 自定义项30
    ,o.zyx31 -- 自定义项31
    ,o.zyx32 -- 自定义项32
    ,o.zyx33 -- 自定义项33
    ,o.zyx34 -- 自定义项34
    ,o.zyx35 -- 自定义项35
    ,o.zyx36 -- 自定义项36
    ,o.zyx37 -- 自定义项37
    ,o.zyx38 -- 自定义项38
    ,o.zyx39 -- 自定义项39
    ,o.zyx4 -- 自定义项4
    ,o.zyx40 -- 自定义项40
    ,o.zyx41 -- 自定义项41
    ,o.zyx42 -- 自定义项42
    ,o.zyx43 -- 自定义项43
    ,o.zyx44 -- 自定义项44
    ,o.zyx45 -- 自定义项45
    ,o.zyx46 -- 自定义项46
    ,o.zyx47 -- 自定义项47
    ,o.zyx48 -- 自定义项48
    ,o.zyx49 -- 自定义项49
    ,o.zyx5 -- 自定义项5
    ,o.zyx50 -- 自定义项50
    ,o.zyx51 -- 自定义项51
    ,o.zyx52 -- 自定义项52
    ,o.zyx53 -- 自定义项53
    ,o.zyx54 -- 自定义项54
    ,o.zyx55 -- 自定义项55
    ,o.zyx56 -- 自定义项56
    ,o.zyx57 -- 自定义项57
    ,o.zyx58 -- 自定义项58
    ,o.zyx59 -- 自定义项59
    ,o.zyx6 -- 自定义项6
    ,o.zyx60 -- 自定义项60
    ,o.zyx61 -- 自定义项61
    ,o.zyx62 -- 自定义项62
    ,o.zyx63 -- 自定义项63
    ,o.zyx64 -- 自定义项64
    ,o.zyx65 -- 自定义项65
    ,o.zyx66 -- 自定义项66
    ,o.zyx67 -- 自定义项67
    ,o.zyx68 -- 自定义项68
    ,o.zyx69 -- 自定义项69
    ,o.zyx7 -- 自定义项7
    ,o.zyx70 -- 自定义项70
    ,o.zyx71 -- 自定义项71
    ,o.zyx72 -- 自定义项72
    ,o.zyx73 -- 自定义项73
    ,o.zyx74 -- 自定义项74
    ,o.zyx75 -- 自定义项75
    ,o.zyx76 -- 自定义项76
    ,o.zyx77 -- 自定义项77
    ,o.zyx78 -- 自定义项78
    ,o.zyx79 -- 自定义项79
    ,o.zyx8 -- 自定义项8
    ,o.zyx80 -- 自定义项80
    ,o.zyx9 -- 自定义项9
    ,o.sdsj -- 收单时间
    ,o.sdyfzt -- 收单验符状态
    ,o.rulecheckmsg -- 
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
from ${iol_schema}.iers_er_bxzb_bk o
    left join ${iol_schema}.iers_er_bxzb_op n
        on
            o.pk_jkbx = n.pk_jkbx
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_er_bxzb_cl d
        on
            o.pk_jkbx = d.pk_jkbx
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_er_bxzb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_er_bxzb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_er_bxzb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_er_bxzb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_er_bxzb exchange partition p_${batch_date} with table ${iol_schema}.iers_er_bxzb_cl;
alter table ${iol_schema}.iers_er_bxzb exchange partition p_20991231 with table ${iol_schema}.iers_er_bxzb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_er_bxzb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_er_bxzb_op purge;
drop table ${iol_schema}.iers_er_bxzb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_er_bxzb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_er_bxzb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
