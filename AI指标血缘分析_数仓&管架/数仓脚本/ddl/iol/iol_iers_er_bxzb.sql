/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_er_bxzb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_er_bxzb
whenever sqlerror continue none;
drop table ${iol_schema}.iers_er_bxzb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_er_bxzb(
    approver varchar2(30) -- 审批人
    ,bbhl number(15,8) -- 本币汇率
    ,bbje number(28,8) -- 报销本币金额
    ,busitype varchar2(30) -- 业务类型
    ,bzbm varchar2(30) -- 币种
    ,cashitem varchar2(30) -- 现金流量项目
    ,cashproj varchar2(30) -- 资金计划项目
    ,center_dept varchar2(30) -- 归口管理部门
    ,checktype varchar2(30) -- 票据类型
    ,cjkbbje number(28,8) -- 冲借款本币金额
    ,cjkybje number(28,8) -- 冲借款原币金额
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,custaccount varchar2(30) -- 客商银行账户
    ,customer varchar2(30) -- 客户
    ,deptid varchar2(30) -- 
    ,deptid_v varchar2(30) -- 
    ,djbh varchar2(45) -- 单据编号
    ,djdl varchar2(3) -- 单据大类
    ,djlxbm varchar2(30) -- 单据类型编码
    ,djrq varchar2(29) -- 单据日期
    ,djzt number(38,0) -- 单据状态
    ,dr number(10,0) -- 删除标志
    ,dwbm varchar2(30) -- 原报销人单位
    ,dwbm_v varchar2(30) -- 报销人单位
    ,dztz_batch varchar2(75) -- 到账通知交易流水号
    ,dztz_billid varchar2(75) -- 到账通知主键
    ,dztz_billno varchar2(75) -- 到账通知单据号
    ,fjzs number(38,0) -- 附件张数
    ,fkyhzh varchar2(30) -- 单位银行账户
    ,flexible_flag varchar2(2) -- 项目-是否柔性控制
    ,freecust varchar2(30) -- 散户
    ,fydeptid varchar2(30) -- 原费用承担部门
    ,fydeptid_v varchar2(30) -- 费用承担部门
    ,fydwbm varchar2(30) -- 原费用承担单位
    ,fydwbm_v varchar2(30) -- 费用承担单位
    ,globalbbhl number(15,8) -- 全局本币汇率
    ,globalbbje number(28,8) -- 全局报销本币金额
    ,globalcjkbbje number(28,8) -- 全局冲借款本币金额
    ,globalhkbbje number(28,8) -- 全局还款本币金额
    ,globaltax_amount number(28,8) -- 全局税金本币金额
    ,globaltni_amount number(28,8) -- 全局不含税本币金额
    ,globalvat_amount number(28,8) -- 全局含税本币金额
    ,globalzfbbje number(28,8) -- 全局支付本币金额
    ,groupbbhl number(15,8) -- 集团本币汇率
    ,groupbbje number(28,8) -- 集团报销本币金额
    ,groupcjkbbje number(28,8) -- 集团冲借款本币金额
    ,grouphkbbje number(28,8) -- 集团还款本币金额
    ,grouptax_amount number(28,8) -- 集团税金本币金额
    ,grouptni_amount number(28,8) -- 集团不含税本币金额
    ,groupvat_amount number(28,8) -- 集团含税本币金额
    ,groupzfbbje number(28,8) -- 集团支付本币金额
    ,hbbm varchar2(30) -- 供应商
    ,hkbbje number(28,8) -- 还款本币金额
    ,hkybje number(28,8) -- 还款原币金额
    ,imag_status varchar2(75) -- 影像状态
    ,ischeck varchar2(2) -- 是否限额
    ,iscostshare varchar2(2) -- 是否分摊
    ,iscusupplier varchar2(2) -- 对公支付
    ,isexpamt varchar2(2) -- 是否待摊
    ,isexpedited varchar2(2) -- 紧急
    ,ismashare varchar2(2) -- 申请单是否分摊
    ,isneedimag varchar2(2) -- 需要影像扫描
    ,jkbxr varchar2(30) -- 报销人
    ,jobid varchar2(30) -- 项目
    ,jsfs varchar2(30) -- 结算方式
    ,jsh varchar2(45) -- 结算号
    ,jsr varchar2(30) -- 签字人
    ,jsrq varchar2(29) -- 签字日期
    ,kjnd varchar2(6) -- 会计年度
    ,kjqj varchar2(3) -- 会计期间
    ,mngaccid varchar2(30) -- 管理账户
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最终修改人
    ,officialprintdate varchar2(29) -- 正式打印日期
    ,officialprintuser varchar2(30) -- 正式打印人
    ,operator varchar2(30) -- 录入人
    ,orgtax_amount number(28,8) -- 税金组织本币金额
    ,orgtni_amount number(28,8) -- 不含税组织本位币金额
    ,orgvat_amount number(28,8) -- 含税组织本位币金额
    ,paydate varchar2(29) -- 支付日期
    ,payflag number(38,0) -- 支付状态
    ,payman varchar2(30) -- 支付人
    ,paytarget number(38,0) -- 收款对象
    ,pjh varchar2(30) -- 票据号
    ,pk_billtype varchar2(30) -- 单据类型
    ,pk_brand varchar2(30) -- 品牌
    ,pk_campaign varchar2(30) -- 营销活动
    ,pk_cashaccount varchar2(30) -- 现金帐户
    ,pk_checkele varchar2(30) -- 核算要素
    ,pk_contractno varchar2(30) -- 付款合同
    ,pk_fiorg varchar2(30) -- 财务组织
    ,pk_group varchar2(30) -- 集团
    ,pk_item varchar2(30) -- 费用申请单
    ,pk_jkbx varchar2(30) -- 报销单标识
    ,pk_matters varchar2(30) -- 营销事项
    ,pk_org varchar2(30) -- 原报销单位
    ,pk_org_v varchar2(30) -- 报销单位
    ,pk_payorg varchar2(30) -- 原支付组织
    ,pk_payorg_v varchar2(30) -- 支付组织
    ,pk_pcorg varchar2(30) -- 原利润中心
    ,pk_pcorg_v varchar2(30) -- 利润中心
    ,pk_proline varchar2(30) -- 产品线
    ,pk_resacostcenter varchar2(30) -- 成本中心
    ,pk_tradetypeid varchar2(30) -- 交易类型
    ,projecttask varchar2(30) -- 项目任务
    ,qcbz varchar2(2) -- 期初标志
    ,qzzt number(38,0) -- 清帐状态
    ,receiver varchar2(30) -- 收款人
    ,red_status number(38,0) -- 红冲标志
    ,redbillpk varchar2(30) -- 红冲单据主键
    ,reimrule varchar2(768) -- 报销标准
    ,saga_btxid varchar2(96) -- 当前分支id
    ,saga_frozen number(38,0) -- 是否冻结
    ,saga_gtxid varchar2(96) -- 全局事务id
    ,saga_status number(38,0) -- 事务状态
    ,shrq varchar2(29) -- 审批时间
    ,skyhzh varchar2(30) -- 个人银行账户
    ,spzt number(38,0) -- 审批状态
    ,src_ybz_id varchar2(75) -- 友报账id
    ,srcbilltype varchar2(75) -- 来源单据类型
    ,srcsystem varchar2(150) -- 来源系统
    ,srctype varchar2(75) -- 来源类型
    ,start_period varchar2(75) -- 开始摊销期间
    ,sxbz number(38,0) -- 生效状态
    ,szxmid varchar2(30) -- 收支项目
    ,tax_amount number(28,8) -- 税金金额
    ,tax_rate number(28,8) -- 税率
    ,tbb_period varchar2(29) -- 预算占用期间
    ,tni_amount number(28,8) -- 不含税金额
    ,total number(28,8) -- 合计金额
    ,total_period number(38,0) -- 总摊销期
    ,ts varchar2(29) -- 时间戳
    ,vat_amount number(28,8) -- 含税金额
    ,vouchertag number(38,0) -- 凭证标志
    ,ybje number(28,8) -- 报销原币金额
    ,zfbbje number(28,8) -- 支付本币金额
    ,zfybje number(28,8) -- 支付原币金额
    ,zy varchar2(384) -- 事由
    ,zyx1 varchar2(152) -- 自定义项1
    ,zyx10 varchar2(152) -- 自定义项10
    ,zyx11 varchar2(152) -- 自定义项11
    ,zyx12 varchar2(152) -- 自定义项12
    ,zyx13 varchar2(152) -- 自定义项13
    ,zyx14 varchar2(152) -- 自定义项14
    ,zyx15 varchar2(152) -- 自定义项15
    ,zyx16 varchar2(152) -- 自定义项16
    ,zyx17 varchar2(152) -- 自定义项17
    ,zyx18 varchar2(152) -- 自定义项18
    ,zyx19 varchar2(152) -- 自定义项19
    ,zyx2 varchar2(152) -- 自定义项2
    ,zyx20 varchar2(152) -- 自定义项20
    ,zyx21 varchar2(152) -- 自定义项21
    ,zyx22 varchar2(152) -- 自定义项22
    ,zyx23 varchar2(152) -- 自定义项23
    ,zyx24 varchar2(152) -- 自定义项24
    ,zyx25 varchar2(152) -- 自定义项25
    ,zyx26 varchar2(1500) -- 自定义项26
    ,zyx27 varchar2(152) -- 自定义项27
    ,zyx28 varchar2(152) -- 自定义项28
    ,zyx29 varchar2(152) -- 自定义项29
    ,zyx3 varchar2(152) -- 自定义项3
    ,zyx30 varchar2(152) -- 自定义项30
    ,zyx31 varchar2(152) -- 自定义项31
    ,zyx32 varchar2(152) -- 自定义项32
    ,zyx33 varchar2(152) -- 自定义项33
    ,zyx34 varchar2(152) -- 自定义项34
    ,zyx35 varchar2(152) -- 自定义项35
    ,zyx36 varchar2(152) -- 自定义项36
    ,zyx37 varchar2(152) -- 自定义项37
    ,zyx38 varchar2(152) -- 自定义项38
    ,zyx39 varchar2(152) -- 自定义项39
    ,zyx4 varchar2(152) -- 自定义项4
    ,zyx40 varchar2(152) -- 自定义项40
    ,zyx41 varchar2(152) -- 自定义项41
    ,zyx42 varchar2(152) -- 自定义项42
    ,zyx43 varchar2(152) -- 自定义项43
    ,zyx44 varchar2(152) -- 自定义项44
    ,zyx45 varchar2(152) -- 自定义项45
    ,zyx46 varchar2(152) -- 自定义项46
    ,zyx47 varchar2(152) -- 自定义项47
    ,zyx48 varchar2(152) -- 自定义项48
    ,zyx49 varchar2(152) -- 自定义项49
    ,zyx5 varchar2(3000) -- 自定义项5
    ,zyx50 varchar2(152) -- 自定义项50
    ,zyx51 varchar2(152) -- 自定义项51
    ,zyx52 varchar2(152) -- 自定义项52
    ,zyx53 varchar2(152) -- 自定义项53
    ,zyx54 varchar2(152) -- 自定义项54
    ,zyx55 varchar2(152) -- 自定义项55
    ,zyx56 varchar2(152) -- 自定义项56
    ,zyx57 varchar2(152) -- 自定义项57
    ,zyx58 varchar2(152) -- 自定义项58
    ,zyx59 varchar2(152) -- 自定义项59
    ,zyx6 varchar2(152) -- 自定义项6
    ,zyx60 varchar2(152) -- 自定义项60
    ,zyx61 varchar2(152) -- 自定义项61
    ,zyx62 varchar2(152) -- 自定义项62
    ,zyx63 varchar2(152) -- 自定义项63
    ,zyx64 varchar2(152) -- 自定义项64
    ,zyx65 varchar2(152) -- 自定义项65
    ,zyx66 varchar2(152) -- 自定义项66
    ,zyx67 varchar2(152) -- 自定义项67
    ,zyx68 varchar2(152) -- 自定义项68
    ,zyx69 varchar2(152) -- 自定义项69
    ,zyx7 varchar2(152) -- 自定义项7
    ,zyx70 varchar2(152) -- 自定义项70
    ,zyx71 varchar2(152) -- 自定义项71
    ,zyx72 varchar2(152) -- 自定义项72
    ,zyx73 varchar2(152) -- 自定义项73
    ,zyx74 varchar2(152) -- 自定义项74
    ,zyx75 varchar2(152) -- 自定义项75
    ,zyx76 varchar2(152) -- 自定义项76
    ,zyx77 varchar2(152) -- 自定义项77
    ,zyx78 varchar2(152) -- 自定义项78
    ,zyx79 varchar2(152) -- 自定义项79
    ,zyx8 varchar2(152) -- 自定义项8
    ,zyx80 varchar2(152) -- 自定义项80
    ,zyx9 varchar2(152) -- 自定义项9
    ,sdsj varchar2(29) -- 收单时间
    ,sdyfzt varchar2(75) -- 收单验符状态
    ,rulecheckmsg varchar2(152) -- 
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
grant select on ${iol_schema}.iers_er_bxzb to ${iml_schema};
grant select on ${iol_schema}.iers_er_bxzb to ${icl_schema};
grant select on ${iol_schema}.iers_er_bxzb to ${idl_schema};
grant select on ${iol_schema}.iers_er_bxzb to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_er_bxzb is '新费用明细表(主表)';
comment on column ${iol_schema}.iers_er_bxzb.approver is '审批人';
comment on column ${iol_schema}.iers_er_bxzb.bbhl is '本币汇率';
comment on column ${iol_schema}.iers_er_bxzb.bbje is '报销本币金额';
comment on column ${iol_schema}.iers_er_bxzb.busitype is '业务类型';
comment on column ${iol_schema}.iers_er_bxzb.bzbm is '币种';
comment on column ${iol_schema}.iers_er_bxzb.cashitem is '现金流量项目';
comment on column ${iol_schema}.iers_er_bxzb.cashproj is '资金计划项目';
comment on column ${iol_schema}.iers_er_bxzb.center_dept is '归口管理部门';
comment on column ${iol_schema}.iers_er_bxzb.checktype is '票据类型';
comment on column ${iol_schema}.iers_er_bxzb.cjkbbje is '冲借款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.cjkybje is '冲借款原币金额';
comment on column ${iol_schema}.iers_er_bxzb.creationtime is '创建时间';
comment on column ${iol_schema}.iers_er_bxzb.creator is '创建人';
comment on column ${iol_schema}.iers_er_bxzb.custaccount is '客商银行账户';
comment on column ${iol_schema}.iers_er_bxzb.customer is '客户';
comment on column ${iol_schema}.iers_er_bxzb.deptid is '';
comment on column ${iol_schema}.iers_er_bxzb.deptid_v is '';
comment on column ${iol_schema}.iers_er_bxzb.djbh is '单据编号';
comment on column ${iol_schema}.iers_er_bxzb.djdl is '单据大类';
comment on column ${iol_schema}.iers_er_bxzb.djlxbm is '单据类型编码';
comment on column ${iol_schema}.iers_er_bxzb.djrq is '单据日期';
comment on column ${iol_schema}.iers_er_bxzb.djzt is '单据状态';
comment on column ${iol_schema}.iers_er_bxzb.dr is '删除标志';
comment on column ${iol_schema}.iers_er_bxzb.dwbm is '原报销人单位';
comment on column ${iol_schema}.iers_er_bxzb.dwbm_v is '报销人单位';
comment on column ${iol_schema}.iers_er_bxzb.dztz_batch is '到账通知交易流水号';
comment on column ${iol_schema}.iers_er_bxzb.dztz_billid is '到账通知主键';
comment on column ${iol_schema}.iers_er_bxzb.dztz_billno is '到账通知单据号';
comment on column ${iol_schema}.iers_er_bxzb.fjzs is '附件张数';
comment on column ${iol_schema}.iers_er_bxzb.fkyhzh is '单位银行账户';
comment on column ${iol_schema}.iers_er_bxzb.flexible_flag is '项目-是否柔性控制';
comment on column ${iol_schema}.iers_er_bxzb.freecust is '散户';
comment on column ${iol_schema}.iers_er_bxzb.fydeptid is '原费用承担部门';
comment on column ${iol_schema}.iers_er_bxzb.fydeptid_v is '费用承担部门';
comment on column ${iol_schema}.iers_er_bxzb.fydwbm is '原费用承担单位';
comment on column ${iol_schema}.iers_er_bxzb.fydwbm_v is '费用承担单位';
comment on column ${iol_schema}.iers_er_bxzb.globalbbhl is '全局本币汇率';
comment on column ${iol_schema}.iers_er_bxzb.globalbbje is '全局报销本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globalcjkbbje is '全局冲借款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globalhkbbje is '全局还款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globaltax_amount is '全局税金本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globaltni_amount is '全局不含税本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globalvat_amount is '全局含税本币金额';
comment on column ${iol_schema}.iers_er_bxzb.globalzfbbje is '全局支付本币金额';
comment on column ${iol_schema}.iers_er_bxzb.groupbbhl is '集团本币汇率';
comment on column ${iol_schema}.iers_er_bxzb.groupbbje is '集团报销本币金额';
comment on column ${iol_schema}.iers_er_bxzb.groupcjkbbje is '集团冲借款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.grouphkbbje is '集团还款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.grouptax_amount is '集团税金本币金额';
comment on column ${iol_schema}.iers_er_bxzb.grouptni_amount is '集团不含税本币金额';
comment on column ${iol_schema}.iers_er_bxzb.groupvat_amount is '集团含税本币金额';
comment on column ${iol_schema}.iers_er_bxzb.groupzfbbje is '集团支付本币金额';
comment on column ${iol_schema}.iers_er_bxzb.hbbm is '供应商';
comment on column ${iol_schema}.iers_er_bxzb.hkbbje is '还款本币金额';
comment on column ${iol_schema}.iers_er_bxzb.hkybje is '还款原币金额';
comment on column ${iol_schema}.iers_er_bxzb.imag_status is '影像状态';
comment on column ${iol_schema}.iers_er_bxzb.ischeck is '是否限额';
comment on column ${iol_schema}.iers_er_bxzb.iscostshare is '是否分摊';
comment on column ${iol_schema}.iers_er_bxzb.iscusupplier is '对公支付';
comment on column ${iol_schema}.iers_er_bxzb.isexpamt is '是否待摊';
comment on column ${iol_schema}.iers_er_bxzb.isexpedited is '紧急';
comment on column ${iol_schema}.iers_er_bxzb.ismashare is '申请单是否分摊';
comment on column ${iol_schema}.iers_er_bxzb.isneedimag is '需要影像扫描';
comment on column ${iol_schema}.iers_er_bxzb.jkbxr is '报销人';
comment on column ${iol_schema}.iers_er_bxzb.jobid is '项目';
comment on column ${iol_schema}.iers_er_bxzb.jsfs is '结算方式';
comment on column ${iol_schema}.iers_er_bxzb.jsh is '结算号';
comment on column ${iol_schema}.iers_er_bxzb.jsr is '签字人';
comment on column ${iol_schema}.iers_er_bxzb.jsrq is '签字日期';
comment on column ${iol_schema}.iers_er_bxzb.kjnd is '会计年度';
comment on column ${iol_schema}.iers_er_bxzb.kjqj is '会计期间';
comment on column ${iol_schema}.iers_er_bxzb.mngaccid is '管理账户';
comment on column ${iol_schema}.iers_er_bxzb.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_er_bxzb.modifier is '最终修改人';
comment on column ${iol_schema}.iers_er_bxzb.officialprintdate is '正式打印日期';
comment on column ${iol_schema}.iers_er_bxzb.officialprintuser is '正式打印人';
comment on column ${iol_schema}.iers_er_bxzb.operator is '录入人';
comment on column ${iol_schema}.iers_er_bxzb.orgtax_amount is '税金组织本币金额';
comment on column ${iol_schema}.iers_er_bxzb.orgtni_amount is '不含税组织本位币金额';
comment on column ${iol_schema}.iers_er_bxzb.orgvat_amount is '含税组织本位币金额';
comment on column ${iol_schema}.iers_er_bxzb.paydate is '支付日期';
comment on column ${iol_schema}.iers_er_bxzb.payflag is '支付状态';
comment on column ${iol_schema}.iers_er_bxzb.payman is '支付人';
comment on column ${iol_schema}.iers_er_bxzb.paytarget is '收款对象';
comment on column ${iol_schema}.iers_er_bxzb.pjh is '票据号';
comment on column ${iol_schema}.iers_er_bxzb.pk_billtype is '单据类型';
comment on column ${iol_schema}.iers_er_bxzb.pk_brand is '品牌';
comment on column ${iol_schema}.iers_er_bxzb.pk_campaign is '营销活动';
comment on column ${iol_schema}.iers_er_bxzb.pk_cashaccount is '现金帐户';
comment on column ${iol_schema}.iers_er_bxzb.pk_checkele is '核算要素';
comment on column ${iol_schema}.iers_er_bxzb.pk_contractno is '付款合同';
comment on column ${iol_schema}.iers_er_bxzb.pk_fiorg is '财务组织';
comment on column ${iol_schema}.iers_er_bxzb.pk_group is '集团';
comment on column ${iol_schema}.iers_er_bxzb.pk_item is '费用申请单';
comment on column ${iol_schema}.iers_er_bxzb.pk_jkbx is '报销单标识';
comment on column ${iol_schema}.iers_er_bxzb.pk_matters is '营销事项';
comment on column ${iol_schema}.iers_er_bxzb.pk_org is '原报销单位';
comment on column ${iol_schema}.iers_er_bxzb.pk_org_v is '报销单位';
comment on column ${iol_schema}.iers_er_bxzb.pk_payorg is '原支付组织';
comment on column ${iol_schema}.iers_er_bxzb.pk_payorg_v is '支付组织';
comment on column ${iol_schema}.iers_er_bxzb.pk_pcorg is '原利润中心';
comment on column ${iol_schema}.iers_er_bxzb.pk_pcorg_v is '利润中心';
comment on column ${iol_schema}.iers_er_bxzb.pk_proline is '产品线';
comment on column ${iol_schema}.iers_er_bxzb.pk_resacostcenter is '成本中心';
comment on column ${iol_schema}.iers_er_bxzb.pk_tradetypeid is '交易类型';
comment on column ${iol_schema}.iers_er_bxzb.projecttask is '项目任务';
comment on column ${iol_schema}.iers_er_bxzb.qcbz is '期初标志';
comment on column ${iol_schema}.iers_er_bxzb.qzzt is '清帐状态';
comment on column ${iol_schema}.iers_er_bxzb.receiver is '收款人';
comment on column ${iol_schema}.iers_er_bxzb.red_status is '红冲标志';
comment on column ${iol_schema}.iers_er_bxzb.redbillpk is '红冲单据主键';
comment on column ${iol_schema}.iers_er_bxzb.reimrule is '报销标准';
comment on column ${iol_schema}.iers_er_bxzb.saga_btxid is '当前分支id';
comment on column ${iol_schema}.iers_er_bxzb.saga_frozen is '是否冻结';
comment on column ${iol_schema}.iers_er_bxzb.saga_gtxid is '全局事务id';
comment on column ${iol_schema}.iers_er_bxzb.saga_status is '事务状态';
comment on column ${iol_schema}.iers_er_bxzb.shrq is '审批时间';
comment on column ${iol_schema}.iers_er_bxzb.skyhzh is '个人银行账户';
comment on column ${iol_schema}.iers_er_bxzb.spzt is '审批状态';
comment on column ${iol_schema}.iers_er_bxzb.src_ybz_id is '友报账id';
comment on column ${iol_schema}.iers_er_bxzb.srcbilltype is '来源单据类型';
comment on column ${iol_schema}.iers_er_bxzb.srcsystem is '来源系统';
comment on column ${iol_schema}.iers_er_bxzb.srctype is '来源类型';
comment on column ${iol_schema}.iers_er_bxzb.start_period is '开始摊销期间';
comment on column ${iol_schema}.iers_er_bxzb.sxbz is '生效状态';
comment on column ${iol_schema}.iers_er_bxzb.szxmid is '收支项目';
comment on column ${iol_schema}.iers_er_bxzb.tax_amount is '税金金额';
comment on column ${iol_schema}.iers_er_bxzb.tax_rate is '税率';
comment on column ${iol_schema}.iers_er_bxzb.tbb_period is '预算占用期间';
comment on column ${iol_schema}.iers_er_bxzb.tni_amount is '不含税金额';
comment on column ${iol_schema}.iers_er_bxzb.total is '合计金额';
comment on column ${iol_schema}.iers_er_bxzb.total_period is '总摊销期';
comment on column ${iol_schema}.iers_er_bxzb.ts is '时间戳';
comment on column ${iol_schema}.iers_er_bxzb.vat_amount is '含税金额';
comment on column ${iol_schema}.iers_er_bxzb.vouchertag is '凭证标志';
comment on column ${iol_schema}.iers_er_bxzb.ybje is '报销原币金额';
comment on column ${iol_schema}.iers_er_bxzb.zfbbje is '支付本币金额';
comment on column ${iol_schema}.iers_er_bxzb.zfybje is '支付原币金额';
comment on column ${iol_schema}.iers_er_bxzb.zy is '事由';
comment on column ${iol_schema}.iers_er_bxzb.zyx1 is '自定义项1';
comment on column ${iol_schema}.iers_er_bxzb.zyx10 is '自定义项10';
comment on column ${iol_schema}.iers_er_bxzb.zyx11 is '自定义项11';
comment on column ${iol_schema}.iers_er_bxzb.zyx12 is '自定义项12';
comment on column ${iol_schema}.iers_er_bxzb.zyx13 is '自定义项13';
comment on column ${iol_schema}.iers_er_bxzb.zyx14 is '自定义项14';
comment on column ${iol_schema}.iers_er_bxzb.zyx15 is '自定义项15';
comment on column ${iol_schema}.iers_er_bxzb.zyx16 is '自定义项16';
comment on column ${iol_schema}.iers_er_bxzb.zyx17 is '自定义项17';
comment on column ${iol_schema}.iers_er_bxzb.zyx18 is '自定义项18';
comment on column ${iol_schema}.iers_er_bxzb.zyx19 is '自定义项19';
comment on column ${iol_schema}.iers_er_bxzb.zyx2 is '自定义项2';
comment on column ${iol_schema}.iers_er_bxzb.zyx20 is '自定义项20';
comment on column ${iol_schema}.iers_er_bxzb.zyx21 is '自定义项21';
comment on column ${iol_schema}.iers_er_bxzb.zyx22 is '自定义项22';
comment on column ${iol_schema}.iers_er_bxzb.zyx23 is '自定义项23';
comment on column ${iol_schema}.iers_er_bxzb.zyx24 is '自定义项24';
comment on column ${iol_schema}.iers_er_bxzb.zyx25 is '自定义项25';
comment on column ${iol_schema}.iers_er_bxzb.zyx26 is '自定义项26';
comment on column ${iol_schema}.iers_er_bxzb.zyx27 is '自定义项27';
comment on column ${iol_schema}.iers_er_bxzb.zyx28 is '自定义项28';
comment on column ${iol_schema}.iers_er_bxzb.zyx29 is '自定义项29';
comment on column ${iol_schema}.iers_er_bxzb.zyx3 is '自定义项3';
comment on column ${iol_schema}.iers_er_bxzb.zyx30 is '自定义项30';
comment on column ${iol_schema}.iers_er_bxzb.zyx31 is '自定义项31';
comment on column ${iol_schema}.iers_er_bxzb.zyx32 is '自定义项32';
comment on column ${iol_schema}.iers_er_bxzb.zyx33 is '自定义项33';
comment on column ${iol_schema}.iers_er_bxzb.zyx34 is '自定义项34';
comment on column ${iol_schema}.iers_er_bxzb.zyx35 is '自定义项35';
comment on column ${iol_schema}.iers_er_bxzb.zyx36 is '自定义项36';
comment on column ${iol_schema}.iers_er_bxzb.zyx37 is '自定义项37';
comment on column ${iol_schema}.iers_er_bxzb.zyx38 is '自定义项38';
comment on column ${iol_schema}.iers_er_bxzb.zyx39 is '自定义项39';
comment on column ${iol_schema}.iers_er_bxzb.zyx4 is '自定义项4';
comment on column ${iol_schema}.iers_er_bxzb.zyx40 is '自定义项40';
comment on column ${iol_schema}.iers_er_bxzb.zyx41 is '自定义项41';
comment on column ${iol_schema}.iers_er_bxzb.zyx42 is '自定义项42';
comment on column ${iol_schema}.iers_er_bxzb.zyx43 is '自定义项43';
comment on column ${iol_schema}.iers_er_bxzb.zyx44 is '自定义项44';
comment on column ${iol_schema}.iers_er_bxzb.zyx45 is '自定义项45';
comment on column ${iol_schema}.iers_er_bxzb.zyx46 is '自定义项46';
comment on column ${iol_schema}.iers_er_bxzb.zyx47 is '自定义项47';
comment on column ${iol_schema}.iers_er_bxzb.zyx48 is '自定义项48';
comment on column ${iol_schema}.iers_er_bxzb.zyx49 is '自定义项49';
comment on column ${iol_schema}.iers_er_bxzb.zyx5 is '自定义项5';
comment on column ${iol_schema}.iers_er_bxzb.zyx50 is '自定义项50';
comment on column ${iol_schema}.iers_er_bxzb.zyx51 is '自定义项51';
comment on column ${iol_schema}.iers_er_bxzb.zyx52 is '自定义项52';
comment on column ${iol_schema}.iers_er_bxzb.zyx53 is '自定义项53';
comment on column ${iol_schema}.iers_er_bxzb.zyx54 is '自定义项54';
comment on column ${iol_schema}.iers_er_bxzb.zyx55 is '自定义项55';
comment on column ${iol_schema}.iers_er_bxzb.zyx56 is '自定义项56';
comment on column ${iol_schema}.iers_er_bxzb.zyx57 is '自定义项57';
comment on column ${iol_schema}.iers_er_bxzb.zyx58 is '自定义项58';
comment on column ${iol_schema}.iers_er_bxzb.zyx59 is '自定义项59';
comment on column ${iol_schema}.iers_er_bxzb.zyx6 is '自定义项6';
comment on column ${iol_schema}.iers_er_bxzb.zyx60 is '自定义项60';
comment on column ${iol_schema}.iers_er_bxzb.zyx61 is '自定义项61';
comment on column ${iol_schema}.iers_er_bxzb.zyx62 is '自定义项62';
comment on column ${iol_schema}.iers_er_bxzb.zyx63 is '自定义项63';
comment on column ${iol_schema}.iers_er_bxzb.zyx64 is '自定义项64';
comment on column ${iol_schema}.iers_er_bxzb.zyx65 is '自定义项65';
comment on column ${iol_schema}.iers_er_bxzb.zyx66 is '自定义项66';
comment on column ${iol_schema}.iers_er_bxzb.zyx67 is '自定义项67';
comment on column ${iol_schema}.iers_er_bxzb.zyx68 is '自定义项68';
comment on column ${iol_schema}.iers_er_bxzb.zyx69 is '自定义项69';
comment on column ${iol_schema}.iers_er_bxzb.zyx7 is '自定义项7';
comment on column ${iol_schema}.iers_er_bxzb.zyx70 is '自定义项70';
comment on column ${iol_schema}.iers_er_bxzb.zyx71 is '自定义项71';
comment on column ${iol_schema}.iers_er_bxzb.zyx72 is '自定义项72';
comment on column ${iol_schema}.iers_er_bxzb.zyx73 is '自定义项73';
comment on column ${iol_schema}.iers_er_bxzb.zyx74 is '自定义项74';
comment on column ${iol_schema}.iers_er_bxzb.zyx75 is '自定义项75';
comment on column ${iol_schema}.iers_er_bxzb.zyx76 is '自定义项76';
comment on column ${iol_schema}.iers_er_bxzb.zyx77 is '自定义项77';
comment on column ${iol_schema}.iers_er_bxzb.zyx78 is '自定义项78';
comment on column ${iol_schema}.iers_er_bxzb.zyx79 is '自定义项79';
comment on column ${iol_schema}.iers_er_bxzb.zyx8 is '自定义项8';
comment on column ${iol_schema}.iers_er_bxzb.zyx80 is '自定义项80';
comment on column ${iol_schema}.iers_er_bxzb.zyx9 is '自定义项9';
comment on column ${iol_schema}.iers_er_bxzb.sdsj is '收单时间';
comment on column ${iol_schema}.iers_er_bxzb.sdyfzt is '收单验符状态';
comment on column ${iol_schema}.iers_er_bxzb.rulecheckmsg is '';
comment on column ${iol_schema}.iers_er_bxzb.start_dt is '开始时间';
comment on column ${iol_schema}.iers_er_bxzb.end_dt is '结束时间';
comment on column ${iol_schema}.iers_er_bxzb.id_mark is '增删标志';
comment on column ${iol_schema}.iers_er_bxzb.etl_timestamp is 'ETL处理时间戳';
