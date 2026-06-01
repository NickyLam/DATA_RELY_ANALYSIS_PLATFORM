/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_er_busitem
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
create table ${iol_schema}.iers_er_busitem_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_er_busitem
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_er_busitem_op purge;
drop table ${iol_schema}.iers_er_busitem_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_er_busitem_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_er_busitem where 0=1;

create table ${iol_schema}.iers_er_busitem_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_er_busitem where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_er_busitem_cl(
            amount -- 金额
            ,bbhl -- 本币汇率
            ,bbje -- 本币金额
            ,bbye -- 本币余额
            ,bzbm -- 币种
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款金额
            ,companypaytype -- 企业支付类型
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,defitem1 -- 自定义项1
            ,defitem10 -- 自定义项10
            ,defitem11 -- 自定义项11
            ,defitem12 -- 自定义项12
            ,defitem13 -- 自定义项13
            ,defitem14 -- 自定义项14
            ,defitem15 -- 自定义项15
            ,defitem16 -- 自定义项16
            ,defitem17 -- 自定义项17
            ,defitem18 -- 自定义项18
            ,defitem19 -- 自定义项19
            ,defitem2 -- 自定义项2
            ,defitem20 -- 自定义项20
            ,defitem21 -- 自定义项21
            ,defitem22 -- 自定义项22
            ,defitem23 -- 自定义项23
            ,defitem24 -- 自定义项24
            ,defitem25 -- 自定义项25
            ,defitem26 -- 自定义项26
            ,defitem27 -- 自定义项27
            ,defitem28 -- 自定义项28
            ,defitem29 -- 自定义项29
            ,defitem3 -- 自定义项3
            ,defitem30 -- 自定义项30
            ,defitem31 -- 自定义项31
            ,defitem32 -- 自定义项32
            ,defitem33 -- 自定义项33
            ,defitem34 -- 自定义项34
            ,defitem35 -- 自定义项35
            ,defitem36 -- 自定义项36
            ,defitem37 -- 自定义项37
            ,defitem38 -- 自定义项38
            ,defitem39 -- 自定义项39
            ,defitem4 -- 自定义项4
            ,defitem40 -- 自定义项40
            ,defitem41 -- 自定义项41
            ,defitem42 -- 自定义项42
            ,defitem43 -- 自定义项43
            ,defitem44 -- 自定义项44
            ,defitem45 -- 自定义项45
            ,defitem46 -- 自定义项46
            ,defitem47 -- 自定义项47
            ,defitem48 -- 自定义项48
            ,defitem49 -- 自定义项49
            ,defitem5 -- 自定义项5
            ,defitem50 -- 自定义项50
            ,defitem51 -- 自定义项51
            ,defitem52 -- 自定义项52
            ,defitem53 -- 自定义项53
            ,defitem54 -- 自定义项54
            ,defitem55 -- 自定义项55
            ,defitem56 -- 自定义项56
            ,defitem57 -- 自定义项57
            ,defitem58 -- 自定义项58
            ,defitem59 -- 自定义项59
            ,defitem6 -- 自定义项6
            ,defitem60 -- 自定义项60
            ,defitem61 -- 自定义项61
            ,defitem62 -- 自定义项62
            ,defitem63 -- 自定义项63
            ,defitem64 -- 自定义项64
            ,defitem65 -- 自定义项65
            ,defitem66 -- 自定义项66
            ,defitem67 -- 自定义项67
            ,defitem68 -- 自定义项68
            ,defitem69 -- 自定义项69
            ,defitem7 -- 自定义项7
            ,defitem70 -- 自定义项70
            ,defitem71 -- 自定义项71
            ,defitem72 -- 自定义项72
            ,defitem73 -- 自定义项73
            ,defitem74 -- 自定义项74
            ,defitem75 -- 自定义项75
            ,defitem76 -- 自定义项76
            ,defitem77 -- 自定义项77
            ,defitem78 -- 自定义项78
            ,defitem79 -- 自定义项79
            ,defitem8 -- 自定义项8
            ,defitem80 -- 自定义项80
            ,defitem9 -- 自定义项9
            ,deptid -- 报销人部门
            ,dr -- 删除标志
            ,dwbm -- 报销人单位
            ,fctno -- 合同号
            ,fpdm -- 发票代码
            ,fphm -- 发票号码
            ,fplx -- 发票类型
            ,freecust -- 散户
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局本币金额
            ,globalbbye -- 全局本币余额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团本币金额
            ,groupbbye -- 集团本币余额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款金额
            ,iscompanypay -- 是否企业支付
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paytarget -- 收款对象
            ,pk_brand -- 品牌
            ,pk_busitem -- 报销单业务行标识
            ,pk_checkele -- 核算要素
            ,pk_crmdetail -- pk_crm
            ,pk_fprelation -- 关联发票
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_mtapp_detail -- 费用申请单明细
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心历史版本
            ,pk_proline -- 产品线
            ,pk_reimtype -- 报销类型
            ,pk_resacostcenter -- 成本中心
            ,projecttask -- 项目任务
            ,receiver -- 收款人
            ,rowno -- 行号
            ,sfcb -- 是否超标
            ,skyhzh -- 个人银行账户
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srctype -- 来源类型
            ,szxmid -- 收支项目
            ,tablecode -- 页签编码
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tni_amount -- 不含税金额
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,ybje -- 原币金额
            ,ybye -- 原币余额
            ,yjye -- 预计余额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付金额
            ,fplxpk -- 发票类型主键
            ,generatetype -- 发票生成方式
            ,pk_erminvoice -- 关联发票
            ,pk_erminvoice_b -- 关联发票明细
            ,jxzcje -- 进项转出金额
            ,stxsje -- 视同销售金额
            ,qualitydeposit -- 质保金
            ,pk_resource -- 
            ,pk_resource_b -- 单据来源子表主键
            ,remark -- 备注2
            ,leavedate -- 离开日期
            ,staydates -- 停留日期
            ,bsarrive -- 到达
            ,isconverd -- 是否转换
            ,defitem_convert_reason -- 事由
            ,asale_taxrate -- 税率
            ,asale_vat_amount -- 含税金额
            ,taxitem -- 税收项目
            ,buytaxno -- 购方税号
            ,traveldate -- 旅行日期
            ,deductype -- 演绎类型
            ,enddate -- 结束日期
            ,arrivedate -- 到达日期
            ,taxperiod -- 税期
            ,converexplain -- 自定义
            ,traffictools -- 交通工具
            ,subsidycosts -- 补贴成本
            ,standardcosts -- 标准成本
            ,arrive -- 到达
            ,defitem_asale_reason -- 事由
            ,buyname -- 买名
            ,leave -- 离开
            ,asale_tni_amount -- 不含税金额
            ,notes -- 备注
            ,asale_explain -- 解释
            ,convert_tax -- 销项税
            ,input_tax -- 进项税
            ,companyrealpay -- 公司实付金额
            ,pk_trip_orderno -- 指令状态
            ,asale_tax -- 税
            ,isdeemedsale -- 是否视同销售
            ,startdate -- 开始日期
            ,defitem81 -- 自定义项81
            ,defitem82 -- 自定义项82
            ,defitem83 -- 自定义项83
            ,defitem84 -- 自定义项84
            ,defitem85 -- 自定义项85
            ,defitem86 -- 自定义项86
            ,defitem87 -- 自定义项87
            ,defitem88 -- 自定义项88
            ,defitem89 -- 自定义项89
            ,defitem90 -- 自定义项90
            ,defitem91 -- 自定义项91
            ,defitem92 -- 自定义项92
            ,defitem93 -- 自定义项93
            ,defitem94 -- 自定义项94
            ,defitem95 -- 自定义项95
            ,defitem96 -- 自定义项96
            ,defitem97 -- 自定义项97
            ,defitem98 -- 自定义项98
            ,defitem99 -- 自定义项99
            ,defitem100 -- 自定义项100
            ,defitem101 -- 自定义项101
            ,defitem102 -- 自定义项102
            ,defitem103 -- 自定义项103
            ,defitem104 -- 自定义项104
            ,defitem105 -- 自定义项105
            ,defitem106 -- 自定义项106
            ,defitem107 -- 自定义项107
            ,defitem108 -- 自定义项108
            ,defitem109 -- 自定义项109
            ,defitem110 -- 自定义项110
            ,defitem111 -- 自定义项111
            ,defitem112 -- 自定义项112
            ,defitem113 -- 自定义项113
            ,defitem114 -- 自定义项114
            ,defitem115 -- 自定义项115
            ,defitem116 -- 自定义项116
            ,defitem117 -- 自定义项117
            ,defitem118 -- 自定义项118
            ,defitem119 -- 自定义项119
            ,defitem120 -- 自定义项120
            ,defitem121 -- 自定义项121
            ,defitem122 -- 自定义项122
            ,defitem123 -- 自定义项123
            ,defitem124 -- 自定义项124
            ,defitem125 -- 自定义项125
            ,defitem126 -- 自定义项126
            ,defitem127 -- 自定义项127
            ,defitem128 -- 自定义项128
            ,defitem129 -- 自定义项129
            ,defitem130 -- 自定义项130
            ,defitem131 -- 自定义项131
            ,defitem132 -- 自定义项132
            ,defitem133 -- 自定义项133
            ,defitem134 -- 自定义项134
            ,defitem135 -- 自定义项135
            ,defitem136 -- 自定义项136
            ,defitem137 -- 自定义项137
            ,defitem138 -- 自定义项138
            ,defitem139 -- 自定义项139
            ,defitem140 -- 自定义项140
            ,defitem141 -- 自定义项141
            ,defitem142 -- 自定义项142
            ,defitem143 -- 自定义项143
            ,defitem144 -- 自定义项144
            ,defitem145 -- 自定义项145
            ,defitem146 -- 自定义项146
            ,defitem147 -- 自定义项147
            ,defitem148 -- 自定义项148
            ,defitem149 -- 自定义项149
            ,defitem150 -- 自定义项150
            ,defitem151 -- 自定义项151
            ,defitem152 -- 自定义项152
            ,defitem153 -- 自定义项153
            ,defitem154 -- 自定义项154
            ,defitem155 -- 自定义项155
            ,defitem156 -- 自定义项156
            ,defitem157 -- 自定义项157
            ,defitem158 -- 自定义项158
            ,defitem159 -- 自定义项159
            ,defitem160 -- 自定义项160
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_er_busitem_op(
            amount -- 金额
            ,bbhl -- 本币汇率
            ,bbje -- 本币金额
            ,bbye -- 本币余额
            ,bzbm -- 币种
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款金额
            ,companypaytype -- 企业支付类型
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,defitem1 -- 自定义项1
            ,defitem10 -- 自定义项10
            ,defitem11 -- 自定义项11
            ,defitem12 -- 自定义项12
            ,defitem13 -- 自定义项13
            ,defitem14 -- 自定义项14
            ,defitem15 -- 自定义项15
            ,defitem16 -- 自定义项16
            ,defitem17 -- 自定义项17
            ,defitem18 -- 自定义项18
            ,defitem19 -- 自定义项19
            ,defitem2 -- 自定义项2
            ,defitem20 -- 自定义项20
            ,defitem21 -- 自定义项21
            ,defitem22 -- 自定义项22
            ,defitem23 -- 自定义项23
            ,defitem24 -- 自定义项24
            ,defitem25 -- 自定义项25
            ,defitem26 -- 自定义项26
            ,defitem27 -- 自定义项27
            ,defitem28 -- 自定义项28
            ,defitem29 -- 自定义项29
            ,defitem3 -- 自定义项3
            ,defitem30 -- 自定义项30
            ,defitem31 -- 自定义项31
            ,defitem32 -- 自定义项32
            ,defitem33 -- 自定义项33
            ,defitem34 -- 自定义项34
            ,defitem35 -- 自定义项35
            ,defitem36 -- 自定义项36
            ,defitem37 -- 自定义项37
            ,defitem38 -- 自定义项38
            ,defitem39 -- 自定义项39
            ,defitem4 -- 自定义项4
            ,defitem40 -- 自定义项40
            ,defitem41 -- 自定义项41
            ,defitem42 -- 自定义项42
            ,defitem43 -- 自定义项43
            ,defitem44 -- 自定义项44
            ,defitem45 -- 自定义项45
            ,defitem46 -- 自定义项46
            ,defitem47 -- 自定义项47
            ,defitem48 -- 自定义项48
            ,defitem49 -- 自定义项49
            ,defitem5 -- 自定义项5
            ,defitem50 -- 自定义项50
            ,defitem51 -- 自定义项51
            ,defitem52 -- 自定义项52
            ,defitem53 -- 自定义项53
            ,defitem54 -- 自定义项54
            ,defitem55 -- 自定义项55
            ,defitem56 -- 自定义项56
            ,defitem57 -- 自定义项57
            ,defitem58 -- 自定义项58
            ,defitem59 -- 自定义项59
            ,defitem6 -- 自定义项6
            ,defitem60 -- 自定义项60
            ,defitem61 -- 自定义项61
            ,defitem62 -- 自定义项62
            ,defitem63 -- 自定义项63
            ,defitem64 -- 自定义项64
            ,defitem65 -- 自定义项65
            ,defitem66 -- 自定义项66
            ,defitem67 -- 自定义项67
            ,defitem68 -- 自定义项68
            ,defitem69 -- 自定义项69
            ,defitem7 -- 自定义项7
            ,defitem70 -- 自定义项70
            ,defitem71 -- 自定义项71
            ,defitem72 -- 自定义项72
            ,defitem73 -- 自定义项73
            ,defitem74 -- 自定义项74
            ,defitem75 -- 自定义项75
            ,defitem76 -- 自定义项76
            ,defitem77 -- 自定义项77
            ,defitem78 -- 自定义项78
            ,defitem79 -- 自定义项79
            ,defitem8 -- 自定义项8
            ,defitem80 -- 自定义项80
            ,defitem9 -- 自定义项9
            ,deptid -- 报销人部门
            ,dr -- 删除标志
            ,dwbm -- 报销人单位
            ,fctno -- 合同号
            ,fpdm -- 发票代码
            ,fphm -- 发票号码
            ,fplx -- 发票类型
            ,freecust -- 散户
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局本币金额
            ,globalbbye -- 全局本币余额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团本币金额
            ,groupbbye -- 集团本币余额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款金额
            ,iscompanypay -- 是否企业支付
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paytarget -- 收款对象
            ,pk_brand -- 品牌
            ,pk_busitem -- 报销单业务行标识
            ,pk_checkele -- 核算要素
            ,pk_crmdetail -- pk_crm
            ,pk_fprelation -- 关联发票
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_mtapp_detail -- 费用申请单明细
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心历史版本
            ,pk_proline -- 产品线
            ,pk_reimtype -- 报销类型
            ,pk_resacostcenter -- 成本中心
            ,projecttask -- 项目任务
            ,receiver -- 收款人
            ,rowno -- 行号
            ,sfcb -- 是否超标
            ,skyhzh -- 个人银行账户
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srctype -- 来源类型
            ,szxmid -- 收支项目
            ,tablecode -- 页签编码
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tni_amount -- 不含税金额
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,ybje -- 原币金额
            ,ybye -- 原币余额
            ,yjye -- 预计余额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付金额
            ,fplxpk -- 发票类型主键
            ,generatetype -- 发票生成方式
            ,pk_erminvoice -- 关联发票
            ,pk_erminvoice_b -- 关联发票明细
            ,jxzcje -- 进项转出金额
            ,stxsje -- 视同销售金额
            ,qualitydeposit -- 质保金
            ,pk_resource -- 
            ,pk_resource_b -- 单据来源子表主键
            ,remark -- 备注2
            ,leavedate -- 离开日期
            ,staydates -- 停留日期
            ,bsarrive -- 到达
            ,isconverd -- 是否转换
            ,defitem_convert_reason -- 事由
            ,asale_taxrate -- 税率
            ,asale_vat_amount -- 含税金额
            ,taxitem -- 税收项目
            ,buytaxno -- 购方税号
            ,traveldate -- 旅行日期
            ,deductype -- 演绎类型
            ,enddate -- 结束日期
            ,arrivedate -- 到达日期
            ,taxperiod -- 税期
            ,converexplain -- 自定义
            ,traffictools -- 交通工具
            ,subsidycosts -- 补贴成本
            ,standardcosts -- 标准成本
            ,arrive -- 到达
            ,defitem_asale_reason -- 事由
            ,buyname -- 买名
            ,leave -- 离开
            ,asale_tni_amount -- 不含税金额
            ,notes -- 备注
            ,asale_explain -- 解释
            ,convert_tax -- 销项税
            ,input_tax -- 进项税
            ,companyrealpay -- 公司实付金额
            ,pk_trip_orderno -- 指令状态
            ,asale_tax -- 税
            ,isdeemedsale -- 是否视同销售
            ,startdate -- 开始日期
            ,defitem81 -- 自定义项81
            ,defitem82 -- 自定义项82
            ,defitem83 -- 自定义项83
            ,defitem84 -- 自定义项84
            ,defitem85 -- 自定义项85
            ,defitem86 -- 自定义项86
            ,defitem87 -- 自定义项87
            ,defitem88 -- 自定义项88
            ,defitem89 -- 自定义项89
            ,defitem90 -- 自定义项90
            ,defitem91 -- 自定义项91
            ,defitem92 -- 自定义项92
            ,defitem93 -- 自定义项93
            ,defitem94 -- 自定义项94
            ,defitem95 -- 自定义项95
            ,defitem96 -- 自定义项96
            ,defitem97 -- 自定义项97
            ,defitem98 -- 自定义项98
            ,defitem99 -- 自定义项99
            ,defitem100 -- 自定义项100
            ,defitem101 -- 自定义项101
            ,defitem102 -- 自定义项102
            ,defitem103 -- 自定义项103
            ,defitem104 -- 自定义项104
            ,defitem105 -- 自定义项105
            ,defitem106 -- 自定义项106
            ,defitem107 -- 自定义项107
            ,defitem108 -- 自定义项108
            ,defitem109 -- 自定义项109
            ,defitem110 -- 自定义项110
            ,defitem111 -- 自定义项111
            ,defitem112 -- 自定义项112
            ,defitem113 -- 自定义项113
            ,defitem114 -- 自定义项114
            ,defitem115 -- 自定义项115
            ,defitem116 -- 自定义项116
            ,defitem117 -- 自定义项117
            ,defitem118 -- 自定义项118
            ,defitem119 -- 自定义项119
            ,defitem120 -- 自定义项120
            ,defitem121 -- 自定义项121
            ,defitem122 -- 自定义项122
            ,defitem123 -- 自定义项123
            ,defitem124 -- 自定义项124
            ,defitem125 -- 自定义项125
            ,defitem126 -- 自定义项126
            ,defitem127 -- 自定义项127
            ,defitem128 -- 自定义项128
            ,defitem129 -- 自定义项129
            ,defitem130 -- 自定义项130
            ,defitem131 -- 自定义项131
            ,defitem132 -- 自定义项132
            ,defitem133 -- 自定义项133
            ,defitem134 -- 自定义项134
            ,defitem135 -- 自定义项135
            ,defitem136 -- 自定义项136
            ,defitem137 -- 自定义项137
            ,defitem138 -- 自定义项138
            ,defitem139 -- 自定义项139
            ,defitem140 -- 自定义项140
            ,defitem141 -- 自定义项141
            ,defitem142 -- 自定义项142
            ,defitem143 -- 自定义项143
            ,defitem144 -- 自定义项144
            ,defitem145 -- 自定义项145
            ,defitem146 -- 自定义项146
            ,defitem147 -- 自定义项147
            ,defitem148 -- 自定义项148
            ,defitem149 -- 自定义项149
            ,defitem150 -- 自定义项150
            ,defitem151 -- 自定义项151
            ,defitem152 -- 自定义项152
            ,defitem153 -- 自定义项153
            ,defitem154 -- 自定义项154
            ,defitem155 -- 自定义项155
            ,defitem156 -- 自定义项156
            ,defitem157 -- 自定义项157
            ,defitem158 -- 自定义项158
            ,defitem159 -- 自定义项159
            ,defitem160 -- 自定义项160
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.bbhl, o.bbhl) as bbhl -- 本币汇率
    ,nvl(n.bbje, o.bbje) as bbje -- 本币金额
    ,nvl(n.bbye, o.bbye) as bbye -- 本币余额
    ,nvl(n.bzbm, o.bzbm) as bzbm -- 币种
    ,nvl(n.cjkbbje, o.cjkbbje) as cjkbbje -- 冲借款本币金额
    ,nvl(n.cjkybje, o.cjkybje) as cjkybje -- 冲借款金额
    ,nvl(n.companypaytype, o.companypaytype) as companypaytype -- 企业支付类型
    ,nvl(n.custaccount, o.custaccount) as custaccount -- 客商银行账户
    ,nvl(n.customer, o.customer) as customer -- 客户
    ,nvl(n.defitem1, o.defitem1) as defitem1 -- 自定义项1
    ,nvl(n.defitem10, o.defitem10) as defitem10 -- 自定义项10
    ,nvl(n.defitem11, o.defitem11) as defitem11 -- 自定义项11
    ,nvl(n.defitem12, o.defitem12) as defitem12 -- 自定义项12
    ,nvl(n.defitem13, o.defitem13) as defitem13 -- 自定义项13
    ,nvl(n.defitem14, o.defitem14) as defitem14 -- 自定义项14
    ,nvl(n.defitem15, o.defitem15) as defitem15 -- 自定义项15
    ,nvl(n.defitem16, o.defitem16) as defitem16 -- 自定义项16
    ,nvl(n.defitem17, o.defitem17) as defitem17 -- 自定义项17
    ,nvl(n.defitem18, o.defitem18) as defitem18 -- 自定义项18
    ,nvl(n.defitem19, o.defitem19) as defitem19 -- 自定义项19
    ,nvl(n.defitem2, o.defitem2) as defitem2 -- 自定义项2
    ,nvl(n.defitem20, o.defitem20) as defitem20 -- 自定义项20
    ,nvl(n.defitem21, o.defitem21) as defitem21 -- 自定义项21
    ,nvl(n.defitem22, o.defitem22) as defitem22 -- 自定义项22
    ,nvl(n.defitem23, o.defitem23) as defitem23 -- 自定义项23
    ,nvl(n.defitem24, o.defitem24) as defitem24 -- 自定义项24
    ,nvl(n.defitem25, o.defitem25) as defitem25 -- 自定义项25
    ,nvl(n.defitem26, o.defitem26) as defitem26 -- 自定义项26
    ,nvl(n.defitem27, o.defitem27) as defitem27 -- 自定义项27
    ,nvl(n.defitem28, o.defitem28) as defitem28 -- 自定义项28
    ,nvl(n.defitem29, o.defitem29) as defitem29 -- 自定义项29
    ,nvl(n.defitem3, o.defitem3) as defitem3 -- 自定义项3
    ,nvl(n.defitem30, o.defitem30) as defitem30 -- 自定义项30
    ,nvl(n.defitem31, o.defitem31) as defitem31 -- 自定义项31
    ,nvl(n.defitem32, o.defitem32) as defitem32 -- 自定义项32
    ,nvl(n.defitem33, o.defitem33) as defitem33 -- 自定义项33
    ,nvl(n.defitem34, o.defitem34) as defitem34 -- 自定义项34
    ,nvl(n.defitem35, o.defitem35) as defitem35 -- 自定义项35
    ,nvl(n.defitem36, o.defitem36) as defitem36 -- 自定义项36
    ,nvl(n.defitem37, o.defitem37) as defitem37 -- 自定义项37
    ,nvl(n.defitem38, o.defitem38) as defitem38 -- 自定义项38
    ,nvl(n.defitem39, o.defitem39) as defitem39 -- 自定义项39
    ,nvl(n.defitem4, o.defitem4) as defitem4 -- 自定义项4
    ,nvl(n.defitem40, o.defitem40) as defitem40 -- 自定义项40
    ,nvl(n.defitem41, o.defitem41) as defitem41 -- 自定义项41
    ,nvl(n.defitem42, o.defitem42) as defitem42 -- 自定义项42
    ,nvl(n.defitem43, o.defitem43) as defitem43 -- 自定义项43
    ,nvl(n.defitem44, o.defitem44) as defitem44 -- 自定义项44
    ,nvl(n.defitem45, o.defitem45) as defitem45 -- 自定义项45
    ,nvl(n.defitem46, o.defitem46) as defitem46 -- 自定义项46
    ,nvl(n.defitem47, o.defitem47) as defitem47 -- 自定义项47
    ,nvl(n.defitem48, o.defitem48) as defitem48 -- 自定义项48
    ,nvl(n.defitem49, o.defitem49) as defitem49 -- 自定义项49
    ,nvl(n.defitem5, o.defitem5) as defitem5 -- 自定义项5
    ,nvl(n.defitem50, o.defitem50) as defitem50 -- 自定义项50
    ,nvl(n.defitem51, o.defitem51) as defitem51 -- 自定义项51
    ,nvl(n.defitem52, o.defitem52) as defitem52 -- 自定义项52
    ,nvl(n.defitem53, o.defitem53) as defitem53 -- 自定义项53
    ,nvl(n.defitem54, o.defitem54) as defitem54 -- 自定义项54
    ,nvl(n.defitem55, o.defitem55) as defitem55 -- 自定义项55
    ,nvl(n.defitem56, o.defitem56) as defitem56 -- 自定义项56
    ,nvl(n.defitem57, o.defitem57) as defitem57 -- 自定义项57
    ,nvl(n.defitem58, o.defitem58) as defitem58 -- 自定义项58
    ,nvl(n.defitem59, o.defitem59) as defitem59 -- 自定义项59
    ,nvl(n.defitem6, o.defitem6) as defitem6 -- 自定义项6
    ,nvl(n.defitem60, o.defitem60) as defitem60 -- 自定义项60
    ,nvl(n.defitem61, o.defitem61) as defitem61 -- 自定义项61
    ,nvl(n.defitem62, o.defitem62) as defitem62 -- 自定义项62
    ,nvl(n.defitem63, o.defitem63) as defitem63 -- 自定义项63
    ,nvl(n.defitem64, o.defitem64) as defitem64 -- 自定义项64
    ,nvl(n.defitem65, o.defitem65) as defitem65 -- 自定义项65
    ,nvl(n.defitem66, o.defitem66) as defitem66 -- 自定义项66
    ,nvl(n.defitem67, o.defitem67) as defitem67 -- 自定义项67
    ,nvl(n.defitem68, o.defitem68) as defitem68 -- 自定义项68
    ,nvl(n.defitem69, o.defitem69) as defitem69 -- 自定义项69
    ,nvl(n.defitem7, o.defitem7) as defitem7 -- 自定义项7
    ,nvl(n.defitem70, o.defitem70) as defitem70 -- 自定义项70
    ,nvl(n.defitem71, o.defitem71) as defitem71 -- 自定义项71
    ,nvl(n.defitem72, o.defitem72) as defitem72 -- 自定义项72
    ,nvl(n.defitem73, o.defitem73) as defitem73 -- 自定义项73
    ,nvl(n.defitem74, o.defitem74) as defitem74 -- 自定义项74
    ,nvl(n.defitem75, o.defitem75) as defitem75 -- 自定义项75
    ,nvl(n.defitem76, o.defitem76) as defitem76 -- 自定义项76
    ,nvl(n.defitem77, o.defitem77) as defitem77 -- 自定义项77
    ,nvl(n.defitem78, o.defitem78) as defitem78 -- 自定义项78
    ,nvl(n.defitem79, o.defitem79) as defitem79 -- 自定义项79
    ,nvl(n.defitem8, o.defitem8) as defitem8 -- 自定义项8
    ,nvl(n.defitem80, o.defitem80) as defitem80 -- 自定义项80
    ,nvl(n.defitem9, o.defitem9) as defitem9 -- 自定义项9
    ,nvl(n.deptid, o.deptid) as deptid -- 报销人部门
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.dwbm, o.dwbm) as dwbm -- 报销人单位
    ,nvl(n.fctno, o.fctno) as fctno -- 合同号
    ,nvl(n.fpdm, o.fpdm) as fpdm -- 发票代码
    ,nvl(n.fphm, o.fphm) as fphm -- 发票号码
    ,nvl(n.fplx, o.fplx) as fplx -- 发票类型
    ,nvl(n.freecust, o.freecust) as freecust -- 散户
    ,nvl(n.globalbbhl, o.globalbbhl) as globalbbhl -- 全局本币汇率
    ,nvl(n.globalbbje, o.globalbbje) as globalbbje -- 全局本币金额
    ,nvl(n.globalbbye, o.globalbbye) as globalbbye -- 全局本币余额
    ,nvl(n.globalcjkbbje, o.globalcjkbbje) as globalcjkbbje -- 全局冲借款本币金额
    ,nvl(n.globalhkbbje, o.globalhkbbje) as globalhkbbje -- 全局还款本币金额
    ,nvl(n.globaltax_amount, o.globaltax_amount) as globaltax_amount -- 全局税金本币金额
    ,nvl(n.globaltni_amount, o.globaltni_amount) as globaltni_amount -- 全局不含税本币金额
    ,nvl(n.globalvat_amount, o.globalvat_amount) as globalvat_amount -- 全局含税本币金额
    ,nvl(n.globalzfbbje, o.globalzfbbje) as globalzfbbje -- 全局支付本币金额
    ,nvl(n.groupbbhl, o.groupbbhl) as groupbbhl -- 集团本币汇率
    ,nvl(n.groupbbje, o.groupbbje) as groupbbje -- 集团本币金额
    ,nvl(n.groupbbye, o.groupbbye) as groupbbye -- 集团本币余额
    ,nvl(n.groupcjkbbje, o.groupcjkbbje) as groupcjkbbje -- 集团冲借款本币金额
    ,nvl(n.grouphkbbje, o.grouphkbbje) as grouphkbbje -- 集团还款本币金额
    ,nvl(n.grouptax_amount, o.grouptax_amount) as grouptax_amount -- 集团税金本币金额
    ,nvl(n.grouptni_amount, o.grouptni_amount) as grouptni_amount -- 集团不含税本币金额
    ,nvl(n.groupvat_amount, o.groupvat_amount) as groupvat_amount -- 集团含税本币金额
    ,nvl(n.groupzfbbje, o.groupzfbbje) as groupzfbbje -- 集团支付本币金额
    ,nvl(n.hbbm, o.hbbm) as hbbm -- 供应商
    ,nvl(n.hkbbje, o.hkbbje) as hkbbje -- 还款本币金额
    ,nvl(n.hkybje, o.hkybje) as hkybje -- 还款金额
    ,nvl(n.iscompanypay, o.iscompanypay) as iscompanypay -- 是否企业支付
    ,nvl(n.jkbxr, o.jkbxr) as jkbxr -- 报销人
    ,nvl(n.jobid, o.jobid) as jobid -- 项目
    ,nvl(n.jsfs, o.jsfs) as jsfs -- 结算方式
    ,nvl(n.orgtax_amount, o.orgtax_amount) as orgtax_amount -- 税金组织本币金额
    ,nvl(n.orgtni_amount, o.orgtni_amount) as orgtni_amount -- 不含税组织本位币金额
    ,nvl(n.orgvat_amount, o.orgvat_amount) as orgvat_amount -- 含税组织本位币金额
    ,nvl(n.paytarget, o.paytarget) as paytarget -- 收款对象
    ,nvl(n.pk_brand, o.pk_brand) as pk_brand -- 品牌
    ,nvl(n.pk_busitem, o.pk_busitem) as pk_busitem -- 报销单业务行标识
    ,nvl(n.pk_checkele, o.pk_checkele) as pk_checkele -- 核算要素
    ,nvl(n.pk_crmdetail, o.pk_crmdetail) as pk_crmdetail -- pk_crm
    ,nvl(n.pk_fprelation, o.pk_fprelation) as pk_fprelation -- 关联发票
    ,nvl(n.pk_item, o.pk_item) as pk_item -- 费用申请单
    ,nvl(n.pk_jkbx, o.pk_jkbx) as pk_jkbx -- 报销单标识
    ,nvl(n.pk_mtapp_detail, o.pk_mtapp_detail) as pk_mtapp_detail -- 费用申请单明细
    ,nvl(n.pk_pcorg, o.pk_pcorg) as pk_pcorg -- 利润中心
    ,nvl(n.pk_pcorg_v, o.pk_pcorg_v) as pk_pcorg_v -- 利润中心历史版本
    ,nvl(n.pk_proline, o.pk_proline) as pk_proline -- 产品线
    ,nvl(n.pk_reimtype, o.pk_reimtype) as pk_reimtype -- 报销类型
    ,nvl(n.pk_resacostcenter, o.pk_resacostcenter) as pk_resacostcenter -- 成本中心
    ,nvl(n.projecttask, o.projecttask) as projecttask -- 项目任务
    ,nvl(n.receiver, o.receiver) as receiver -- 收款人
    ,nvl(n.rowno, o.rowno) as rowno -- 行号
    ,nvl(n.sfcb, o.sfcb) as sfcb -- 是否超标
    ,nvl(n.skyhzh, o.skyhzh) as skyhzh -- 个人银行账户
    ,nvl(n.src_ybz_id, o.src_ybz_id) as src_ybz_id -- 友报账id
    ,nvl(n.srcbilltype, o.srcbilltype) as srcbilltype -- 来源单据类型
    ,nvl(n.srctype, o.srctype) as srctype -- 来源类型
    ,nvl(n.szxmid, o.szxmid) as szxmid -- 收支项目
    ,nvl(n.tablecode, o.tablecode) as tablecode -- 页签编码
    ,nvl(n.tax_amount, o.tax_amount) as tax_amount -- 税金金额
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,nvl(n.tni_amount, o.tni_amount) as tni_amount -- 不含税金额
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.vat_amount, o.vat_amount) as vat_amount -- 含税金额
    ,nvl(n.ybje, o.ybje) as ybje -- 原币金额
    ,nvl(n.ybye, o.ybye) as ybye -- 原币余额
    ,nvl(n.yjye, o.yjye) as yjye -- 预计余额
    ,nvl(n.zfbbje, o.zfbbje) as zfbbje -- 支付本币金额
    ,nvl(n.zfybje, o.zfybje) as zfybje -- 支付金额
    ,nvl(n.fplxpk, o.fplxpk) as fplxpk -- 发票类型主键
    ,nvl(n.generatetype, o.generatetype) as generatetype -- 发票生成方式
    ,nvl(n.pk_erminvoice, o.pk_erminvoice) as pk_erminvoice -- 关联发票
    ,nvl(n.pk_erminvoice_b, o.pk_erminvoice_b) as pk_erminvoice_b -- 关联发票明细
    ,nvl(n.jxzcje, o.jxzcje) as jxzcje -- 进项转出金额
    ,nvl(n.stxsje, o.stxsje) as stxsje -- 视同销售金额
    ,nvl(n.qualitydeposit, o.qualitydeposit) as qualitydeposit -- 质保金
    ,nvl(n.pk_resource, o.pk_resource) as pk_resource -- 
    ,nvl(n.pk_resource_b, o.pk_resource_b) as pk_resource_b -- 单据来源子表主键
    ,nvl(n.remark, o.remark) as remark -- 备注2
    ,nvl(n.leavedate, o.leavedate) as leavedate -- 离开日期
    ,nvl(n.staydates, o.staydates) as staydates -- 停留日期
    ,nvl(n.bsarrive, o.bsarrive) as bsarrive -- 到达
    ,nvl(n.isconverd, o.isconverd) as isconverd -- 是否转换
    ,nvl(n.defitem_convert_reason, o.defitem_convert_reason) as defitem_convert_reason -- 事由
    ,nvl(n.asale_taxrate, o.asale_taxrate) as asale_taxrate -- 税率
    ,nvl(n.asale_vat_amount, o.asale_vat_amount) as asale_vat_amount -- 含税金额
    ,nvl(n.taxitem, o.taxitem) as taxitem -- 税收项目
    ,nvl(n.buytaxno, o.buytaxno) as buytaxno -- 购方税号
    ,nvl(n.traveldate, o.traveldate) as traveldate -- 旅行日期
    ,nvl(n.deductype, o.deductype) as deductype -- 演绎类型
    ,nvl(n.enddate, o.enddate) as enddate -- 结束日期
    ,nvl(n.arrivedate, o.arrivedate) as arrivedate -- 到达日期
    ,nvl(n.taxperiod, o.taxperiod) as taxperiod -- 税期
    ,nvl(n.converexplain, o.converexplain) as converexplain -- 自定义
    ,nvl(n.traffictools, o.traffictools) as traffictools -- 交通工具
    ,nvl(n.subsidycosts, o.subsidycosts) as subsidycosts -- 补贴成本
    ,nvl(n.standardcosts, o.standardcosts) as standardcosts -- 标准成本
    ,nvl(n.arrive, o.arrive) as arrive -- 到达
    ,nvl(n.defitem_asale_reason, o.defitem_asale_reason) as defitem_asale_reason -- 事由
    ,nvl(n.buyname, o.buyname) as buyname -- 买名
    ,nvl(n.leave, o.leave) as leave -- 离开
    ,nvl(n.asale_tni_amount, o.asale_tni_amount) as asale_tni_amount -- 不含税金额
    ,nvl(n.notes, o.notes) as notes -- 备注
    ,nvl(n.asale_explain, o.asale_explain) as asale_explain -- 解释
    ,nvl(n.convert_tax, o.convert_tax) as convert_tax -- 销项税
    ,nvl(n.input_tax, o.input_tax) as input_tax -- 进项税
    ,nvl(n.companyrealpay, o.companyrealpay) as companyrealpay -- 公司实付金额
    ,nvl(n.pk_trip_orderno, o.pk_trip_orderno) as pk_trip_orderno -- 指令状态
    ,nvl(n.asale_tax, o.asale_tax) as asale_tax -- 税
    ,nvl(n.isdeemedsale, o.isdeemedsale) as isdeemedsale -- 是否视同销售
    ,nvl(n.startdate, o.startdate) as startdate -- 开始日期
    ,nvl(n.defitem81, o.defitem81) as defitem81 -- 自定义项81
    ,nvl(n.defitem82, o.defitem82) as defitem82 -- 自定义项82
    ,nvl(n.defitem83, o.defitem83) as defitem83 -- 自定义项83
    ,nvl(n.defitem84, o.defitem84) as defitem84 -- 自定义项84
    ,nvl(n.defitem85, o.defitem85) as defitem85 -- 自定义项85
    ,nvl(n.defitem86, o.defitem86) as defitem86 -- 自定义项86
    ,nvl(n.defitem87, o.defitem87) as defitem87 -- 自定义项87
    ,nvl(n.defitem88, o.defitem88) as defitem88 -- 自定义项88
    ,nvl(n.defitem89, o.defitem89) as defitem89 -- 自定义项89
    ,nvl(n.defitem90, o.defitem90) as defitem90 -- 自定义项90
    ,nvl(n.defitem91, o.defitem91) as defitem91 -- 自定义项91
    ,nvl(n.defitem92, o.defitem92) as defitem92 -- 自定义项92
    ,nvl(n.defitem93, o.defitem93) as defitem93 -- 自定义项93
    ,nvl(n.defitem94, o.defitem94) as defitem94 -- 自定义项94
    ,nvl(n.defitem95, o.defitem95) as defitem95 -- 自定义项95
    ,nvl(n.defitem96, o.defitem96) as defitem96 -- 自定义项96
    ,nvl(n.defitem97, o.defitem97) as defitem97 -- 自定义项97
    ,nvl(n.defitem98, o.defitem98) as defitem98 -- 自定义项98
    ,nvl(n.defitem99, o.defitem99) as defitem99 -- 自定义项99
    ,nvl(n.defitem100, o.defitem100) as defitem100 -- 自定义项100
    ,nvl(n.defitem101, o.defitem101) as defitem101 -- 自定义项101
    ,nvl(n.defitem102, o.defitem102) as defitem102 -- 自定义项102
    ,nvl(n.defitem103, o.defitem103) as defitem103 -- 自定义项103
    ,nvl(n.defitem104, o.defitem104) as defitem104 -- 自定义项104
    ,nvl(n.defitem105, o.defitem105) as defitem105 -- 自定义项105
    ,nvl(n.defitem106, o.defitem106) as defitem106 -- 自定义项106
    ,nvl(n.defitem107, o.defitem107) as defitem107 -- 自定义项107
    ,nvl(n.defitem108, o.defitem108) as defitem108 -- 自定义项108
    ,nvl(n.defitem109, o.defitem109) as defitem109 -- 自定义项109
    ,nvl(n.defitem110, o.defitem110) as defitem110 -- 自定义项110
    ,nvl(n.defitem111, o.defitem111) as defitem111 -- 自定义项111
    ,nvl(n.defitem112, o.defitem112) as defitem112 -- 自定义项112
    ,nvl(n.defitem113, o.defitem113) as defitem113 -- 自定义项113
    ,nvl(n.defitem114, o.defitem114) as defitem114 -- 自定义项114
    ,nvl(n.defitem115, o.defitem115) as defitem115 -- 自定义项115
    ,nvl(n.defitem116, o.defitem116) as defitem116 -- 自定义项116
    ,nvl(n.defitem117, o.defitem117) as defitem117 -- 自定义项117
    ,nvl(n.defitem118, o.defitem118) as defitem118 -- 自定义项118
    ,nvl(n.defitem119, o.defitem119) as defitem119 -- 自定义项119
    ,nvl(n.defitem120, o.defitem120) as defitem120 -- 自定义项120
    ,nvl(n.defitem121, o.defitem121) as defitem121 -- 自定义项121
    ,nvl(n.defitem122, o.defitem122) as defitem122 -- 自定义项122
    ,nvl(n.defitem123, o.defitem123) as defitem123 -- 自定义项123
    ,nvl(n.defitem124, o.defitem124) as defitem124 -- 自定义项124
    ,nvl(n.defitem125, o.defitem125) as defitem125 -- 自定义项125
    ,nvl(n.defitem126, o.defitem126) as defitem126 -- 自定义项126
    ,nvl(n.defitem127, o.defitem127) as defitem127 -- 自定义项127
    ,nvl(n.defitem128, o.defitem128) as defitem128 -- 自定义项128
    ,nvl(n.defitem129, o.defitem129) as defitem129 -- 自定义项129
    ,nvl(n.defitem130, o.defitem130) as defitem130 -- 自定义项130
    ,nvl(n.defitem131, o.defitem131) as defitem131 -- 自定义项131
    ,nvl(n.defitem132, o.defitem132) as defitem132 -- 自定义项132
    ,nvl(n.defitem133, o.defitem133) as defitem133 -- 自定义项133
    ,nvl(n.defitem134, o.defitem134) as defitem134 -- 自定义项134
    ,nvl(n.defitem135, o.defitem135) as defitem135 -- 自定义项135
    ,nvl(n.defitem136, o.defitem136) as defitem136 -- 自定义项136
    ,nvl(n.defitem137, o.defitem137) as defitem137 -- 自定义项137
    ,nvl(n.defitem138, o.defitem138) as defitem138 -- 自定义项138
    ,nvl(n.defitem139, o.defitem139) as defitem139 -- 自定义项139
    ,nvl(n.defitem140, o.defitem140) as defitem140 -- 自定义项140
    ,nvl(n.defitem141, o.defitem141) as defitem141 -- 自定义项141
    ,nvl(n.defitem142, o.defitem142) as defitem142 -- 自定义项142
    ,nvl(n.defitem143, o.defitem143) as defitem143 -- 自定义项143
    ,nvl(n.defitem144, o.defitem144) as defitem144 -- 自定义项144
    ,nvl(n.defitem145, o.defitem145) as defitem145 -- 自定义项145
    ,nvl(n.defitem146, o.defitem146) as defitem146 -- 自定义项146
    ,nvl(n.defitem147, o.defitem147) as defitem147 -- 自定义项147
    ,nvl(n.defitem148, o.defitem148) as defitem148 -- 自定义项148
    ,nvl(n.defitem149, o.defitem149) as defitem149 -- 自定义项149
    ,nvl(n.defitem150, o.defitem150) as defitem150 -- 自定义项150
    ,nvl(n.defitem151, o.defitem151) as defitem151 -- 自定义项151
    ,nvl(n.defitem152, o.defitem152) as defitem152 -- 自定义项152
    ,nvl(n.defitem153, o.defitem153) as defitem153 -- 自定义项153
    ,nvl(n.defitem154, o.defitem154) as defitem154 -- 自定义项154
    ,nvl(n.defitem155, o.defitem155) as defitem155 -- 自定义项155
    ,nvl(n.defitem156, o.defitem156) as defitem156 -- 自定义项156
    ,nvl(n.defitem157, o.defitem157) as defitem157 -- 自定义项157
    ,nvl(n.defitem158, o.defitem158) as defitem158 -- 自定义项158
    ,nvl(n.defitem159, o.defitem159) as defitem159 -- 自定义项159
    ,nvl(n.defitem160, o.defitem160) as defitem160 -- 自定义项160
    ,case when
            n.pk_busitem is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_busitem is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_busitem is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_er_busitem_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_er_busitem where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_busitem = n.pk_busitem
where (
        o.pk_busitem is null
    )
    or (
        n.pk_busitem is null
    )
    or (
        o.amount <> n.amount
        or o.bbhl <> n.bbhl
        or o.bbje <> n.bbje
        or o.bbye <> n.bbye
        or o.bzbm <> n.bzbm
        or o.cjkbbje <> n.cjkbbje
        or o.cjkybje <> n.cjkybje
        or o.companypaytype <> n.companypaytype
        or o.custaccount <> n.custaccount
        or o.customer <> n.customer
        or o.defitem1 <> n.defitem1
        or o.defitem10 <> n.defitem10
        or o.defitem11 <> n.defitem11
        or o.defitem12 <> n.defitem12
        or o.defitem13 <> n.defitem13
        or o.defitem14 <> n.defitem14
        or o.defitem15 <> n.defitem15
        or o.defitem16 <> n.defitem16
        or o.defitem17 <> n.defitem17
        or o.defitem18 <> n.defitem18
        or o.defitem19 <> n.defitem19
        or o.defitem2 <> n.defitem2
        or o.defitem20 <> n.defitem20
        or o.defitem21 <> n.defitem21
        or o.defitem22 <> n.defitem22
        or o.defitem23 <> n.defitem23
        or o.defitem24 <> n.defitem24
        or o.defitem25 <> n.defitem25
        or o.defitem26 <> n.defitem26
        or o.defitem27 <> n.defitem27
        or o.defitem28 <> n.defitem28
        or o.defitem29 <> n.defitem29
        or o.defitem3 <> n.defitem3
        or o.defitem30 <> n.defitem30
        or o.defitem31 <> n.defitem31
        or o.defitem32 <> n.defitem32
        or o.defitem33 <> n.defitem33
        or o.defitem34 <> n.defitem34
        or o.defitem35 <> n.defitem35
        or o.defitem36 <> n.defitem36
        or o.defitem37 <> n.defitem37
        or o.defitem38 <> n.defitem38
        or o.defitem39 <> n.defitem39
        or o.defitem4 <> n.defitem4
        or o.defitem40 <> n.defitem40
        or o.defitem41 <> n.defitem41
        or o.defitem42 <> n.defitem42
        or o.defitem43 <> n.defitem43
        or o.defitem44 <> n.defitem44
        or o.defitem45 <> n.defitem45
        or o.defitem46 <> n.defitem46
        or o.defitem47 <> n.defitem47
        or o.defitem48 <> n.defitem48
        or o.defitem49 <> n.defitem49
        or o.defitem5 <> n.defitem5
        or o.defitem50 <> n.defitem50
        or o.defitem51 <> n.defitem51
        or o.defitem52 <> n.defitem52
        or o.defitem53 <> n.defitem53
        or o.defitem54 <> n.defitem54
        or o.defitem55 <> n.defitem55
        or o.defitem56 <> n.defitem56
        or o.defitem57 <> n.defitem57
        or o.defitem58 <> n.defitem58
        or o.defitem59 <> n.defitem59
        or o.defitem6 <> n.defitem6
        or o.defitem60 <> n.defitem60
        or o.defitem61 <> n.defitem61
        or o.defitem62 <> n.defitem62
        or o.defitem63 <> n.defitem63
        or o.defitem64 <> n.defitem64
        or o.defitem65 <> n.defitem65
        or o.defitem66 <> n.defitem66
        or o.defitem67 <> n.defitem67
        or o.defitem68 <> n.defitem68
        or o.defitem69 <> n.defitem69
        or o.defitem7 <> n.defitem7
        or o.defitem70 <> n.defitem70
        or o.defitem71 <> n.defitem71
        or o.defitem72 <> n.defitem72
        or o.defitem73 <> n.defitem73
        or o.defitem74 <> n.defitem74
        or o.defitem75 <> n.defitem75
        or o.defitem76 <> n.defitem76
        or o.defitem77 <> n.defitem77
        or o.defitem78 <> n.defitem78
        or o.defitem79 <> n.defitem79
        or o.defitem8 <> n.defitem8
        or o.defitem80 <> n.defitem80
        or o.defitem9 <> n.defitem9
        or o.deptid <> n.deptid
        or o.dr <> n.dr
        or o.dwbm <> n.dwbm
        or o.fctno <> n.fctno
        or o.fpdm <> n.fpdm
        or o.fphm <> n.fphm
        or o.fplx <> n.fplx
        or o.freecust <> n.freecust
        or o.globalbbhl <> n.globalbbhl
        or o.globalbbje <> n.globalbbje
        or o.globalbbye <> n.globalbbye
        or o.globalcjkbbje <> n.globalcjkbbje
        or o.globalhkbbje <> n.globalhkbbje
        or o.globaltax_amount <> n.globaltax_amount
        or o.globaltni_amount <> n.globaltni_amount
        or o.globalvat_amount <> n.globalvat_amount
        or o.globalzfbbje <> n.globalzfbbje
        or o.groupbbhl <> n.groupbbhl
        or o.groupbbje <> n.groupbbje
        or o.groupbbye <> n.groupbbye
        or o.groupcjkbbje <> n.groupcjkbbje
        or o.grouphkbbje <> n.grouphkbbje
        or o.grouptax_amount <> n.grouptax_amount
        or o.grouptni_amount <> n.grouptni_amount
        or o.groupvat_amount <> n.groupvat_amount
        or o.groupzfbbje <> n.groupzfbbje
        or o.hbbm <> n.hbbm
        or o.hkbbje <> n.hkbbje
        or o.hkybje <> n.hkybje
        or o.iscompanypay <> n.iscompanypay
        or o.jkbxr <> n.jkbxr
        or o.jobid <> n.jobid
        or o.jsfs <> n.jsfs
        or o.orgtax_amount <> n.orgtax_amount
        or o.orgtni_amount <> n.orgtni_amount
        or o.orgvat_amount <> n.orgvat_amount
        or o.paytarget <> n.paytarget
        or o.pk_brand <> n.pk_brand
        or o.pk_checkele <> n.pk_checkele
        or o.pk_crmdetail <> n.pk_crmdetail
        or o.pk_fprelation <> n.pk_fprelation
        or o.pk_item <> n.pk_item
        or o.pk_jkbx <> n.pk_jkbx
        or o.pk_mtapp_detail <> n.pk_mtapp_detail
        or o.pk_pcorg <> n.pk_pcorg
        or o.pk_pcorg_v <> n.pk_pcorg_v
        or o.pk_proline <> n.pk_proline
        or o.pk_reimtype <> n.pk_reimtype
        or o.pk_resacostcenter <> n.pk_resacostcenter
        or o.projecttask <> n.projecttask
        or o.receiver <> n.receiver
        or o.rowno <> n.rowno
        or o.sfcb <> n.sfcb
        or o.skyhzh <> n.skyhzh
        or o.src_ybz_id <> n.src_ybz_id
        or o.srcbilltype <> n.srcbilltype
        or o.srctype <> n.srctype
        or o.szxmid <> n.szxmid
        or o.tablecode <> n.tablecode
        or o.tax_amount <> n.tax_amount
        or o.tax_rate <> n.tax_rate
        or o.tni_amount <> n.tni_amount
        or o.ts <> n.ts
        or o.vat_amount <> n.vat_amount
        or o.ybje <> n.ybje
        or o.ybye <> n.ybye
        or o.yjye <> n.yjye
        or o.zfbbje <> n.zfbbje
        or o.zfybje <> n.zfybje
        or o.fplxpk <> n.fplxpk
        or o.generatetype <> n.generatetype
        or o.pk_erminvoice <> n.pk_erminvoice
        or o.pk_erminvoice_b <> n.pk_erminvoice_b
        or o.jxzcje <> n.jxzcje
        or o.stxsje <> n.stxsje
        or o.qualitydeposit <> n.qualitydeposit
        or o.pk_resource <> n.pk_resource
        or o.pk_resource_b <> n.pk_resource_b
        or o.remark <> n.remark
        or o.leavedate <> n.leavedate
        or o.staydates <> n.staydates
        or o.bsarrive <> n.bsarrive
        or o.isconverd <> n.isconverd
        or o.defitem_convert_reason <> n.defitem_convert_reason
        or o.asale_taxrate <> n.asale_taxrate
        or o.asale_vat_amount <> n.asale_vat_amount
        or o.taxitem <> n.taxitem
        or o.buytaxno <> n.buytaxno
        or o.traveldate <> n.traveldate
        or o.deductype <> n.deductype
        or o.enddate <> n.enddate
        or o.arrivedate <> n.arrivedate
        or o.taxperiod <> n.taxperiod
        or o.converexplain <> n.converexplain
        or o.traffictools <> n.traffictools
        or o.subsidycosts <> n.subsidycosts
        or o.standardcosts <> n.standardcosts
        or o.arrive <> n.arrive
        or o.defitem_asale_reason <> n.defitem_asale_reason
        or o.buyname <> n.buyname
        or o.leave <> n.leave
        or o.asale_tni_amount <> n.asale_tni_amount
        or o.notes <> n.notes
        or o.asale_explain <> n.asale_explain
        or o.convert_tax <> n.convert_tax
        or o.input_tax <> n.input_tax
        or o.companyrealpay <> n.companyrealpay
        or o.pk_trip_orderno <> n.pk_trip_orderno
        or o.asale_tax <> n.asale_tax
        or o.isdeemedsale <> n.isdeemedsale
        or o.startdate <> n.startdate
        or o.defitem81 <> n.defitem81
        or o.defitem82 <> n.defitem82
        or o.defitem83 <> n.defitem83
        or o.defitem84 <> n.defitem84
        or o.defitem85 <> n.defitem85
        or o.defitem86 <> n.defitem86
        or o.defitem87 <> n.defitem87
        or o.defitem88 <> n.defitem88
        or o.defitem89 <> n.defitem89
        or o.defitem90 <> n.defitem90
        or o.defitem91 <> n.defitem91
        or o.defitem92 <> n.defitem92
        or o.defitem93 <> n.defitem93
        or o.defitem94 <> n.defitem94
        or o.defitem95 <> n.defitem95
        or o.defitem96 <> n.defitem96
        or o.defitem97 <> n.defitem97
        or o.defitem98 <> n.defitem98
        or o.defitem99 <> n.defitem99
        or o.defitem100 <> n.defitem100
        or o.defitem101 <> n.defitem101
        or o.defitem102 <> n.defitem102
        or o.defitem103 <> n.defitem103
        or o.defitem104 <> n.defitem104
        or o.defitem105 <> n.defitem105
        or o.defitem106 <> n.defitem106
        or o.defitem107 <> n.defitem107
        or o.defitem108 <> n.defitem108
        or o.defitem109 <> n.defitem109
        or o.defitem110 <> n.defitem110
        or o.defitem111 <> n.defitem111
        or o.defitem112 <> n.defitem112
        or o.defitem113 <> n.defitem113
        or o.defitem114 <> n.defitem114
        or o.defitem115 <> n.defitem115
        or o.defitem116 <> n.defitem116
        or o.defitem117 <> n.defitem117
        or o.defitem118 <> n.defitem118
        or o.defitem119 <> n.defitem119
        or o.defitem120 <> n.defitem120
        or o.defitem121 <> n.defitem121
        or o.defitem122 <> n.defitem122
        or o.defitem123 <> n.defitem123
        or o.defitem124 <> n.defitem124
        or o.defitem125 <> n.defitem125
        or o.defitem126 <> n.defitem126
        or o.defitem127 <> n.defitem127
        or o.defitem128 <> n.defitem128
        or o.defitem129 <> n.defitem129
        or o.defitem130 <> n.defitem130
        or o.defitem131 <> n.defitem131
        or o.defitem132 <> n.defitem132
        or o.defitem133 <> n.defitem133
        or o.defitem134 <> n.defitem134
        or o.defitem135 <> n.defitem135
        or o.defitem136 <> n.defitem136
        or o.defitem137 <> n.defitem137
        or o.defitem138 <> n.defitem138
        or o.defitem139 <> n.defitem139
        or o.defitem140 <> n.defitem140
        or o.defitem141 <> n.defitem141
        or o.defitem142 <> n.defitem142
        or o.defitem143 <> n.defitem143
        or o.defitem144 <> n.defitem144
        or o.defitem145 <> n.defitem145
        or o.defitem146 <> n.defitem146
        or o.defitem147 <> n.defitem147
        or o.defitem148 <> n.defitem148
        or o.defitem149 <> n.defitem149
        or o.defitem150 <> n.defitem150
        or o.defitem151 <> n.defitem151
        or o.defitem152 <> n.defitem152
        or o.defitem153 <> n.defitem153
        or o.defitem154 <> n.defitem154
        or o.defitem155 <> n.defitem155
        or o.defitem156 <> n.defitem156
        or o.defitem157 <> n.defitem157
        or o.defitem158 <> n.defitem158
        or o.defitem159 <> n.defitem159
        or o.defitem160 <> n.defitem160
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_er_busitem_cl(
            amount -- 金额
            ,bbhl -- 本币汇率
            ,bbje -- 本币金额
            ,bbye -- 本币余额
            ,bzbm -- 币种
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款金额
            ,companypaytype -- 企业支付类型
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,defitem1 -- 自定义项1
            ,defitem10 -- 自定义项10
            ,defitem11 -- 自定义项11
            ,defitem12 -- 自定义项12
            ,defitem13 -- 自定义项13
            ,defitem14 -- 自定义项14
            ,defitem15 -- 自定义项15
            ,defitem16 -- 自定义项16
            ,defitem17 -- 自定义项17
            ,defitem18 -- 自定义项18
            ,defitem19 -- 自定义项19
            ,defitem2 -- 自定义项2
            ,defitem20 -- 自定义项20
            ,defitem21 -- 自定义项21
            ,defitem22 -- 自定义项22
            ,defitem23 -- 自定义项23
            ,defitem24 -- 自定义项24
            ,defitem25 -- 自定义项25
            ,defitem26 -- 自定义项26
            ,defitem27 -- 自定义项27
            ,defitem28 -- 自定义项28
            ,defitem29 -- 自定义项29
            ,defitem3 -- 自定义项3
            ,defitem30 -- 自定义项30
            ,defitem31 -- 自定义项31
            ,defitem32 -- 自定义项32
            ,defitem33 -- 自定义项33
            ,defitem34 -- 自定义项34
            ,defitem35 -- 自定义项35
            ,defitem36 -- 自定义项36
            ,defitem37 -- 自定义项37
            ,defitem38 -- 自定义项38
            ,defitem39 -- 自定义项39
            ,defitem4 -- 自定义项4
            ,defitem40 -- 自定义项40
            ,defitem41 -- 自定义项41
            ,defitem42 -- 自定义项42
            ,defitem43 -- 自定义项43
            ,defitem44 -- 自定义项44
            ,defitem45 -- 自定义项45
            ,defitem46 -- 自定义项46
            ,defitem47 -- 自定义项47
            ,defitem48 -- 自定义项48
            ,defitem49 -- 自定义项49
            ,defitem5 -- 自定义项5
            ,defitem50 -- 自定义项50
            ,defitem51 -- 自定义项51
            ,defitem52 -- 自定义项52
            ,defitem53 -- 自定义项53
            ,defitem54 -- 自定义项54
            ,defitem55 -- 自定义项55
            ,defitem56 -- 自定义项56
            ,defitem57 -- 自定义项57
            ,defitem58 -- 自定义项58
            ,defitem59 -- 自定义项59
            ,defitem6 -- 自定义项6
            ,defitem60 -- 自定义项60
            ,defitem61 -- 自定义项61
            ,defitem62 -- 自定义项62
            ,defitem63 -- 自定义项63
            ,defitem64 -- 自定义项64
            ,defitem65 -- 自定义项65
            ,defitem66 -- 自定义项66
            ,defitem67 -- 自定义项67
            ,defitem68 -- 自定义项68
            ,defitem69 -- 自定义项69
            ,defitem7 -- 自定义项7
            ,defitem70 -- 自定义项70
            ,defitem71 -- 自定义项71
            ,defitem72 -- 自定义项72
            ,defitem73 -- 自定义项73
            ,defitem74 -- 自定义项74
            ,defitem75 -- 自定义项75
            ,defitem76 -- 自定义项76
            ,defitem77 -- 自定义项77
            ,defitem78 -- 自定义项78
            ,defitem79 -- 自定义项79
            ,defitem8 -- 自定义项8
            ,defitem80 -- 自定义项80
            ,defitem9 -- 自定义项9
            ,deptid -- 报销人部门
            ,dr -- 删除标志
            ,dwbm -- 报销人单位
            ,fctno -- 合同号
            ,fpdm -- 发票代码
            ,fphm -- 发票号码
            ,fplx -- 发票类型
            ,freecust -- 散户
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局本币金额
            ,globalbbye -- 全局本币余额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团本币金额
            ,groupbbye -- 集团本币余额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款金额
            ,iscompanypay -- 是否企业支付
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paytarget -- 收款对象
            ,pk_brand -- 品牌
            ,pk_busitem -- 报销单业务行标识
            ,pk_checkele -- 核算要素
            ,pk_crmdetail -- pk_crm
            ,pk_fprelation -- 关联发票
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_mtapp_detail -- 费用申请单明细
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心历史版本
            ,pk_proline -- 产品线
            ,pk_reimtype -- 报销类型
            ,pk_resacostcenter -- 成本中心
            ,projecttask -- 项目任务
            ,receiver -- 收款人
            ,rowno -- 行号
            ,sfcb -- 是否超标
            ,skyhzh -- 个人银行账户
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srctype -- 来源类型
            ,szxmid -- 收支项目
            ,tablecode -- 页签编码
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tni_amount -- 不含税金额
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,ybje -- 原币金额
            ,ybye -- 原币余额
            ,yjye -- 预计余额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付金额
            ,fplxpk -- 发票类型主键
            ,generatetype -- 发票生成方式
            ,pk_erminvoice -- 关联发票
            ,pk_erminvoice_b -- 关联发票明细
            ,jxzcje -- 进项转出金额
            ,stxsje -- 视同销售金额
            ,qualitydeposit -- 质保金
            ,pk_resource -- 
            ,pk_resource_b -- 单据来源子表主键
            ,remark -- 备注2
            ,leavedate -- 离开日期
            ,staydates -- 停留日期
            ,bsarrive -- 到达
            ,isconverd -- 是否转换
            ,defitem_convert_reason -- 事由
            ,asale_taxrate -- 税率
            ,asale_vat_amount -- 含税金额
            ,taxitem -- 税收项目
            ,buytaxno -- 购方税号
            ,traveldate -- 旅行日期
            ,deductype -- 演绎类型
            ,enddate -- 结束日期
            ,arrivedate -- 到达日期
            ,taxperiod -- 税期
            ,converexplain -- 自定义
            ,traffictools -- 交通工具
            ,subsidycosts -- 补贴成本
            ,standardcosts -- 标准成本
            ,arrive -- 到达
            ,defitem_asale_reason -- 事由
            ,buyname -- 买名
            ,leave -- 离开
            ,asale_tni_amount -- 不含税金额
            ,notes -- 备注
            ,asale_explain -- 解释
            ,convert_tax -- 销项税
            ,input_tax -- 进项税
            ,companyrealpay -- 公司实付金额
            ,pk_trip_orderno -- 指令状态
            ,asale_tax -- 税
            ,isdeemedsale -- 是否视同销售
            ,startdate -- 开始日期
            ,defitem81 -- 自定义项81
            ,defitem82 -- 自定义项82
            ,defitem83 -- 自定义项83
            ,defitem84 -- 自定义项84
            ,defitem85 -- 自定义项85
            ,defitem86 -- 自定义项86
            ,defitem87 -- 自定义项87
            ,defitem88 -- 自定义项88
            ,defitem89 -- 自定义项89
            ,defitem90 -- 自定义项90
            ,defitem91 -- 自定义项91
            ,defitem92 -- 自定义项92
            ,defitem93 -- 自定义项93
            ,defitem94 -- 自定义项94
            ,defitem95 -- 自定义项95
            ,defitem96 -- 自定义项96
            ,defitem97 -- 自定义项97
            ,defitem98 -- 自定义项98
            ,defitem99 -- 自定义项99
            ,defitem100 -- 自定义项100
            ,defitem101 -- 自定义项101
            ,defitem102 -- 自定义项102
            ,defitem103 -- 自定义项103
            ,defitem104 -- 自定义项104
            ,defitem105 -- 自定义项105
            ,defitem106 -- 自定义项106
            ,defitem107 -- 自定义项107
            ,defitem108 -- 自定义项108
            ,defitem109 -- 自定义项109
            ,defitem110 -- 自定义项110
            ,defitem111 -- 自定义项111
            ,defitem112 -- 自定义项112
            ,defitem113 -- 自定义项113
            ,defitem114 -- 自定义项114
            ,defitem115 -- 自定义项115
            ,defitem116 -- 自定义项116
            ,defitem117 -- 自定义项117
            ,defitem118 -- 自定义项118
            ,defitem119 -- 自定义项119
            ,defitem120 -- 自定义项120
            ,defitem121 -- 自定义项121
            ,defitem122 -- 自定义项122
            ,defitem123 -- 自定义项123
            ,defitem124 -- 自定义项124
            ,defitem125 -- 自定义项125
            ,defitem126 -- 自定义项126
            ,defitem127 -- 自定义项127
            ,defitem128 -- 自定义项128
            ,defitem129 -- 自定义项129
            ,defitem130 -- 自定义项130
            ,defitem131 -- 自定义项131
            ,defitem132 -- 自定义项132
            ,defitem133 -- 自定义项133
            ,defitem134 -- 自定义项134
            ,defitem135 -- 自定义项135
            ,defitem136 -- 自定义项136
            ,defitem137 -- 自定义项137
            ,defitem138 -- 自定义项138
            ,defitem139 -- 自定义项139
            ,defitem140 -- 自定义项140
            ,defitem141 -- 自定义项141
            ,defitem142 -- 自定义项142
            ,defitem143 -- 自定义项143
            ,defitem144 -- 自定义项144
            ,defitem145 -- 自定义项145
            ,defitem146 -- 自定义项146
            ,defitem147 -- 自定义项147
            ,defitem148 -- 自定义项148
            ,defitem149 -- 自定义项149
            ,defitem150 -- 自定义项150
            ,defitem151 -- 自定义项151
            ,defitem152 -- 自定义项152
            ,defitem153 -- 自定义项153
            ,defitem154 -- 自定义项154
            ,defitem155 -- 自定义项155
            ,defitem156 -- 自定义项156
            ,defitem157 -- 自定义项157
            ,defitem158 -- 自定义项158
            ,defitem159 -- 自定义项159
            ,defitem160 -- 自定义项160
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_er_busitem_op(
            amount -- 金额
            ,bbhl -- 本币汇率
            ,bbje -- 本币金额
            ,bbye -- 本币余额
            ,bzbm -- 币种
            ,cjkbbje -- 冲借款本币金额
            ,cjkybje -- 冲借款金额
            ,companypaytype -- 企业支付类型
            ,custaccount -- 客商银行账户
            ,customer -- 客户
            ,defitem1 -- 自定义项1
            ,defitem10 -- 自定义项10
            ,defitem11 -- 自定义项11
            ,defitem12 -- 自定义项12
            ,defitem13 -- 自定义项13
            ,defitem14 -- 自定义项14
            ,defitem15 -- 自定义项15
            ,defitem16 -- 自定义项16
            ,defitem17 -- 自定义项17
            ,defitem18 -- 自定义项18
            ,defitem19 -- 自定义项19
            ,defitem2 -- 自定义项2
            ,defitem20 -- 自定义项20
            ,defitem21 -- 自定义项21
            ,defitem22 -- 自定义项22
            ,defitem23 -- 自定义项23
            ,defitem24 -- 自定义项24
            ,defitem25 -- 自定义项25
            ,defitem26 -- 自定义项26
            ,defitem27 -- 自定义项27
            ,defitem28 -- 自定义项28
            ,defitem29 -- 自定义项29
            ,defitem3 -- 自定义项3
            ,defitem30 -- 自定义项30
            ,defitem31 -- 自定义项31
            ,defitem32 -- 自定义项32
            ,defitem33 -- 自定义项33
            ,defitem34 -- 自定义项34
            ,defitem35 -- 自定义项35
            ,defitem36 -- 自定义项36
            ,defitem37 -- 自定义项37
            ,defitem38 -- 自定义项38
            ,defitem39 -- 自定义项39
            ,defitem4 -- 自定义项4
            ,defitem40 -- 自定义项40
            ,defitem41 -- 自定义项41
            ,defitem42 -- 自定义项42
            ,defitem43 -- 自定义项43
            ,defitem44 -- 自定义项44
            ,defitem45 -- 自定义项45
            ,defitem46 -- 自定义项46
            ,defitem47 -- 自定义项47
            ,defitem48 -- 自定义项48
            ,defitem49 -- 自定义项49
            ,defitem5 -- 自定义项5
            ,defitem50 -- 自定义项50
            ,defitem51 -- 自定义项51
            ,defitem52 -- 自定义项52
            ,defitem53 -- 自定义项53
            ,defitem54 -- 自定义项54
            ,defitem55 -- 自定义项55
            ,defitem56 -- 自定义项56
            ,defitem57 -- 自定义项57
            ,defitem58 -- 自定义项58
            ,defitem59 -- 自定义项59
            ,defitem6 -- 自定义项6
            ,defitem60 -- 自定义项60
            ,defitem61 -- 自定义项61
            ,defitem62 -- 自定义项62
            ,defitem63 -- 自定义项63
            ,defitem64 -- 自定义项64
            ,defitem65 -- 自定义项65
            ,defitem66 -- 自定义项66
            ,defitem67 -- 自定义项67
            ,defitem68 -- 自定义项68
            ,defitem69 -- 自定义项69
            ,defitem7 -- 自定义项7
            ,defitem70 -- 自定义项70
            ,defitem71 -- 自定义项71
            ,defitem72 -- 自定义项72
            ,defitem73 -- 自定义项73
            ,defitem74 -- 自定义项74
            ,defitem75 -- 自定义项75
            ,defitem76 -- 自定义项76
            ,defitem77 -- 自定义项77
            ,defitem78 -- 自定义项78
            ,defitem79 -- 自定义项79
            ,defitem8 -- 自定义项8
            ,defitem80 -- 自定义项80
            ,defitem9 -- 自定义项9
            ,deptid -- 报销人部门
            ,dr -- 删除标志
            ,dwbm -- 报销人单位
            ,fctno -- 合同号
            ,fpdm -- 发票代码
            ,fphm -- 发票号码
            ,fplx -- 发票类型
            ,freecust -- 散户
            ,globalbbhl -- 全局本币汇率
            ,globalbbje -- 全局本币金额
            ,globalbbye -- 全局本币余额
            ,globalcjkbbje -- 全局冲借款本币金额
            ,globalhkbbje -- 全局还款本币金额
            ,globaltax_amount -- 全局税金本币金额
            ,globaltni_amount -- 全局不含税本币金额
            ,globalvat_amount -- 全局含税本币金额
            ,globalzfbbje -- 全局支付本币金额
            ,groupbbhl -- 集团本币汇率
            ,groupbbje -- 集团本币金额
            ,groupbbye -- 集团本币余额
            ,groupcjkbbje -- 集团冲借款本币金额
            ,grouphkbbje -- 集团还款本币金额
            ,grouptax_amount -- 集团税金本币金额
            ,grouptni_amount -- 集团不含税本币金额
            ,groupvat_amount -- 集团含税本币金额
            ,groupzfbbje -- 集团支付本币金额
            ,hbbm -- 供应商
            ,hkbbje -- 还款本币金额
            ,hkybje -- 还款金额
            ,iscompanypay -- 是否企业支付
            ,jkbxr -- 报销人
            ,jobid -- 项目
            ,jsfs -- 结算方式
            ,orgtax_amount -- 税金组织本币金额
            ,orgtni_amount -- 不含税组织本位币金额
            ,orgvat_amount -- 含税组织本位币金额
            ,paytarget -- 收款对象
            ,pk_brand -- 品牌
            ,pk_busitem -- 报销单业务行标识
            ,pk_checkele -- 核算要素
            ,pk_crmdetail -- pk_crm
            ,pk_fprelation -- 关联发票
            ,pk_item -- 费用申请单
            ,pk_jkbx -- 报销单标识
            ,pk_mtapp_detail -- 费用申请单明细
            ,pk_pcorg -- 利润中心
            ,pk_pcorg_v -- 利润中心历史版本
            ,pk_proline -- 产品线
            ,pk_reimtype -- 报销类型
            ,pk_resacostcenter -- 成本中心
            ,projecttask -- 项目任务
            ,receiver -- 收款人
            ,rowno -- 行号
            ,sfcb -- 是否超标
            ,skyhzh -- 个人银行账户
            ,src_ybz_id -- 友报账id
            ,srcbilltype -- 来源单据类型
            ,srctype -- 来源类型
            ,szxmid -- 收支项目
            ,tablecode -- 页签编码
            ,tax_amount -- 税金金额
            ,tax_rate -- 税率
            ,tni_amount -- 不含税金额
            ,ts -- 时间戳
            ,vat_amount -- 含税金额
            ,ybje -- 原币金额
            ,ybye -- 原币余额
            ,yjye -- 预计余额
            ,zfbbje -- 支付本币金额
            ,zfybje -- 支付金额
            ,fplxpk -- 发票类型主键
            ,generatetype -- 发票生成方式
            ,pk_erminvoice -- 关联发票
            ,pk_erminvoice_b -- 关联发票明细
            ,jxzcje -- 进项转出金额
            ,stxsje -- 视同销售金额
            ,qualitydeposit -- 质保金
            ,pk_resource -- 
            ,pk_resource_b -- 单据来源子表主键
            ,remark -- 备注2
            ,leavedate -- 离开日期
            ,staydates -- 停留日期
            ,bsarrive -- 到达
            ,isconverd -- 是否转换
            ,defitem_convert_reason -- 事由
            ,asale_taxrate -- 税率
            ,asale_vat_amount -- 含税金额
            ,taxitem -- 税收项目
            ,buytaxno -- 购方税号
            ,traveldate -- 旅行日期
            ,deductype -- 演绎类型
            ,enddate -- 结束日期
            ,arrivedate -- 到达日期
            ,taxperiod -- 税期
            ,converexplain -- 自定义
            ,traffictools -- 交通工具
            ,subsidycosts -- 补贴成本
            ,standardcosts -- 标准成本
            ,arrive -- 到达
            ,defitem_asale_reason -- 事由
            ,buyname -- 买名
            ,leave -- 离开
            ,asale_tni_amount -- 不含税金额
            ,notes -- 备注
            ,asale_explain -- 解释
            ,convert_tax -- 销项税
            ,input_tax -- 进项税
            ,companyrealpay -- 公司实付金额
            ,pk_trip_orderno -- 指令状态
            ,asale_tax -- 税
            ,isdeemedsale -- 是否视同销售
            ,startdate -- 开始日期
            ,defitem81 -- 自定义项81
            ,defitem82 -- 自定义项82
            ,defitem83 -- 自定义项83
            ,defitem84 -- 自定义项84
            ,defitem85 -- 自定义项85
            ,defitem86 -- 自定义项86
            ,defitem87 -- 自定义项87
            ,defitem88 -- 自定义项88
            ,defitem89 -- 自定义项89
            ,defitem90 -- 自定义项90
            ,defitem91 -- 自定义项91
            ,defitem92 -- 自定义项92
            ,defitem93 -- 自定义项93
            ,defitem94 -- 自定义项94
            ,defitem95 -- 自定义项95
            ,defitem96 -- 自定义项96
            ,defitem97 -- 自定义项97
            ,defitem98 -- 自定义项98
            ,defitem99 -- 自定义项99
            ,defitem100 -- 自定义项100
            ,defitem101 -- 自定义项101
            ,defitem102 -- 自定义项102
            ,defitem103 -- 自定义项103
            ,defitem104 -- 自定义项104
            ,defitem105 -- 自定义项105
            ,defitem106 -- 自定义项106
            ,defitem107 -- 自定义项107
            ,defitem108 -- 自定义项108
            ,defitem109 -- 自定义项109
            ,defitem110 -- 自定义项110
            ,defitem111 -- 自定义项111
            ,defitem112 -- 自定义项112
            ,defitem113 -- 自定义项113
            ,defitem114 -- 自定义项114
            ,defitem115 -- 自定义项115
            ,defitem116 -- 自定义项116
            ,defitem117 -- 自定义项117
            ,defitem118 -- 自定义项118
            ,defitem119 -- 自定义项119
            ,defitem120 -- 自定义项120
            ,defitem121 -- 自定义项121
            ,defitem122 -- 自定义项122
            ,defitem123 -- 自定义项123
            ,defitem124 -- 自定义项124
            ,defitem125 -- 自定义项125
            ,defitem126 -- 自定义项126
            ,defitem127 -- 自定义项127
            ,defitem128 -- 自定义项128
            ,defitem129 -- 自定义项129
            ,defitem130 -- 自定义项130
            ,defitem131 -- 自定义项131
            ,defitem132 -- 自定义项132
            ,defitem133 -- 自定义项133
            ,defitem134 -- 自定义项134
            ,defitem135 -- 自定义项135
            ,defitem136 -- 自定义项136
            ,defitem137 -- 自定义项137
            ,defitem138 -- 自定义项138
            ,defitem139 -- 自定义项139
            ,defitem140 -- 自定义项140
            ,defitem141 -- 自定义项141
            ,defitem142 -- 自定义项142
            ,defitem143 -- 自定义项143
            ,defitem144 -- 自定义项144
            ,defitem145 -- 自定义项145
            ,defitem146 -- 自定义项146
            ,defitem147 -- 自定义项147
            ,defitem148 -- 自定义项148
            ,defitem149 -- 自定义项149
            ,defitem150 -- 自定义项150
            ,defitem151 -- 自定义项151
            ,defitem152 -- 自定义项152
            ,defitem153 -- 自定义项153
            ,defitem154 -- 自定义项154
            ,defitem155 -- 自定义项155
            ,defitem156 -- 自定义项156
            ,defitem157 -- 自定义项157
            ,defitem158 -- 自定义项158
            ,defitem159 -- 自定义项159
            ,defitem160 -- 自定义项160
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amount -- 金额
    ,o.bbhl -- 本币汇率
    ,o.bbje -- 本币金额
    ,o.bbye -- 本币余额
    ,o.bzbm -- 币种
    ,o.cjkbbje -- 冲借款本币金额
    ,o.cjkybje -- 冲借款金额
    ,o.companypaytype -- 企业支付类型
    ,o.custaccount -- 客商银行账户
    ,o.customer -- 客户
    ,o.defitem1 -- 自定义项1
    ,o.defitem10 -- 自定义项10
    ,o.defitem11 -- 自定义项11
    ,o.defitem12 -- 自定义项12
    ,o.defitem13 -- 自定义项13
    ,o.defitem14 -- 自定义项14
    ,o.defitem15 -- 自定义项15
    ,o.defitem16 -- 自定义项16
    ,o.defitem17 -- 自定义项17
    ,o.defitem18 -- 自定义项18
    ,o.defitem19 -- 自定义项19
    ,o.defitem2 -- 自定义项2
    ,o.defitem20 -- 自定义项20
    ,o.defitem21 -- 自定义项21
    ,o.defitem22 -- 自定义项22
    ,o.defitem23 -- 自定义项23
    ,o.defitem24 -- 自定义项24
    ,o.defitem25 -- 自定义项25
    ,o.defitem26 -- 自定义项26
    ,o.defitem27 -- 自定义项27
    ,o.defitem28 -- 自定义项28
    ,o.defitem29 -- 自定义项29
    ,o.defitem3 -- 自定义项3
    ,o.defitem30 -- 自定义项30
    ,o.defitem31 -- 自定义项31
    ,o.defitem32 -- 自定义项32
    ,o.defitem33 -- 自定义项33
    ,o.defitem34 -- 自定义项34
    ,o.defitem35 -- 自定义项35
    ,o.defitem36 -- 自定义项36
    ,o.defitem37 -- 自定义项37
    ,o.defitem38 -- 自定义项38
    ,o.defitem39 -- 自定义项39
    ,o.defitem4 -- 自定义项4
    ,o.defitem40 -- 自定义项40
    ,o.defitem41 -- 自定义项41
    ,o.defitem42 -- 自定义项42
    ,o.defitem43 -- 自定义项43
    ,o.defitem44 -- 自定义项44
    ,o.defitem45 -- 自定义项45
    ,o.defitem46 -- 自定义项46
    ,o.defitem47 -- 自定义项47
    ,o.defitem48 -- 自定义项48
    ,o.defitem49 -- 自定义项49
    ,o.defitem5 -- 自定义项5
    ,o.defitem50 -- 自定义项50
    ,o.defitem51 -- 自定义项51
    ,o.defitem52 -- 自定义项52
    ,o.defitem53 -- 自定义项53
    ,o.defitem54 -- 自定义项54
    ,o.defitem55 -- 自定义项55
    ,o.defitem56 -- 自定义项56
    ,o.defitem57 -- 自定义项57
    ,o.defitem58 -- 自定义项58
    ,o.defitem59 -- 自定义项59
    ,o.defitem6 -- 自定义项6
    ,o.defitem60 -- 自定义项60
    ,o.defitem61 -- 自定义项61
    ,o.defitem62 -- 自定义项62
    ,o.defitem63 -- 自定义项63
    ,o.defitem64 -- 自定义项64
    ,o.defitem65 -- 自定义项65
    ,o.defitem66 -- 自定义项66
    ,o.defitem67 -- 自定义项67
    ,o.defitem68 -- 自定义项68
    ,o.defitem69 -- 自定义项69
    ,o.defitem7 -- 自定义项7
    ,o.defitem70 -- 自定义项70
    ,o.defitem71 -- 自定义项71
    ,o.defitem72 -- 自定义项72
    ,o.defitem73 -- 自定义项73
    ,o.defitem74 -- 自定义项74
    ,o.defitem75 -- 自定义项75
    ,o.defitem76 -- 自定义项76
    ,o.defitem77 -- 自定义项77
    ,o.defitem78 -- 自定义项78
    ,o.defitem79 -- 自定义项79
    ,o.defitem8 -- 自定义项8
    ,o.defitem80 -- 自定义项80
    ,o.defitem9 -- 自定义项9
    ,o.deptid -- 报销人部门
    ,o.dr -- 删除标志
    ,o.dwbm -- 报销人单位
    ,o.fctno -- 合同号
    ,o.fpdm -- 发票代码
    ,o.fphm -- 发票号码
    ,o.fplx -- 发票类型
    ,o.freecust -- 散户
    ,o.globalbbhl -- 全局本币汇率
    ,o.globalbbje -- 全局本币金额
    ,o.globalbbye -- 全局本币余额
    ,o.globalcjkbbje -- 全局冲借款本币金额
    ,o.globalhkbbje -- 全局还款本币金额
    ,o.globaltax_amount -- 全局税金本币金额
    ,o.globaltni_amount -- 全局不含税本币金额
    ,o.globalvat_amount -- 全局含税本币金额
    ,o.globalzfbbje -- 全局支付本币金额
    ,o.groupbbhl -- 集团本币汇率
    ,o.groupbbje -- 集团本币金额
    ,o.groupbbye -- 集团本币余额
    ,o.groupcjkbbje -- 集团冲借款本币金额
    ,o.grouphkbbje -- 集团还款本币金额
    ,o.grouptax_amount -- 集团税金本币金额
    ,o.grouptni_amount -- 集团不含税本币金额
    ,o.groupvat_amount -- 集团含税本币金额
    ,o.groupzfbbje -- 集团支付本币金额
    ,o.hbbm -- 供应商
    ,o.hkbbje -- 还款本币金额
    ,o.hkybje -- 还款金额
    ,o.iscompanypay -- 是否企业支付
    ,o.jkbxr -- 报销人
    ,o.jobid -- 项目
    ,o.jsfs -- 结算方式
    ,o.orgtax_amount -- 税金组织本币金额
    ,o.orgtni_amount -- 不含税组织本位币金额
    ,o.orgvat_amount -- 含税组织本位币金额
    ,o.paytarget -- 收款对象
    ,o.pk_brand -- 品牌
    ,o.pk_busitem -- 报销单业务行标识
    ,o.pk_checkele -- 核算要素
    ,o.pk_crmdetail -- pk_crm
    ,o.pk_fprelation -- 关联发票
    ,o.pk_item -- 费用申请单
    ,o.pk_jkbx -- 报销单标识
    ,o.pk_mtapp_detail -- 费用申请单明细
    ,o.pk_pcorg -- 利润中心
    ,o.pk_pcorg_v -- 利润中心历史版本
    ,o.pk_proline -- 产品线
    ,o.pk_reimtype -- 报销类型
    ,o.pk_resacostcenter -- 成本中心
    ,o.projecttask -- 项目任务
    ,o.receiver -- 收款人
    ,o.rowno -- 行号
    ,o.sfcb -- 是否超标
    ,o.skyhzh -- 个人银行账户
    ,o.src_ybz_id -- 友报账id
    ,o.srcbilltype -- 来源单据类型
    ,o.srctype -- 来源类型
    ,o.szxmid -- 收支项目
    ,o.tablecode -- 页签编码
    ,o.tax_amount -- 税金金额
    ,o.tax_rate -- 税率
    ,o.tni_amount -- 不含税金额
    ,o.ts -- 时间戳
    ,o.vat_amount -- 含税金额
    ,o.ybje -- 原币金额
    ,o.ybye -- 原币余额
    ,o.yjye -- 预计余额
    ,o.zfbbje -- 支付本币金额
    ,o.zfybje -- 支付金额
    ,o.fplxpk -- 发票类型主键
    ,o.generatetype -- 发票生成方式
    ,o.pk_erminvoice -- 关联发票
    ,o.pk_erminvoice_b -- 关联发票明细
    ,o.jxzcje -- 进项转出金额
    ,o.stxsje -- 视同销售金额
    ,o.qualitydeposit -- 质保金
    ,o.pk_resource -- 
    ,o.pk_resource_b -- 单据来源子表主键
    ,o.remark -- 备注2
    ,o.leavedate -- 离开日期
    ,o.staydates -- 停留日期
    ,o.bsarrive -- 到达
    ,o.isconverd -- 是否转换
    ,o.defitem_convert_reason -- 事由
    ,o.asale_taxrate -- 税率
    ,o.asale_vat_amount -- 含税金额
    ,o.taxitem -- 税收项目
    ,o.buytaxno -- 购方税号
    ,o.traveldate -- 旅行日期
    ,o.deductype -- 演绎类型
    ,o.enddate -- 结束日期
    ,o.arrivedate -- 到达日期
    ,o.taxperiod -- 税期
    ,o.converexplain -- 自定义
    ,o.traffictools -- 交通工具
    ,o.subsidycosts -- 补贴成本
    ,o.standardcosts -- 标准成本
    ,o.arrive -- 到达
    ,o.defitem_asale_reason -- 事由
    ,o.buyname -- 买名
    ,o.leave -- 离开
    ,o.asale_tni_amount -- 不含税金额
    ,o.notes -- 备注
    ,o.asale_explain -- 解释
    ,o.convert_tax -- 销项税
    ,o.input_tax -- 进项税
    ,o.companyrealpay -- 公司实付金额
    ,o.pk_trip_orderno -- 指令状态
    ,o.asale_tax -- 税
    ,o.isdeemedsale -- 是否视同销售
    ,o.startdate -- 开始日期
    ,o.defitem81 -- 自定义项81
    ,o.defitem82 -- 自定义项82
    ,o.defitem83 -- 自定义项83
    ,o.defitem84 -- 自定义项84
    ,o.defitem85 -- 自定义项85
    ,o.defitem86 -- 自定义项86
    ,o.defitem87 -- 自定义项87
    ,o.defitem88 -- 自定义项88
    ,o.defitem89 -- 自定义项89
    ,o.defitem90 -- 自定义项90
    ,o.defitem91 -- 自定义项91
    ,o.defitem92 -- 自定义项92
    ,o.defitem93 -- 自定义项93
    ,o.defitem94 -- 自定义项94
    ,o.defitem95 -- 自定义项95
    ,o.defitem96 -- 自定义项96
    ,o.defitem97 -- 自定义项97
    ,o.defitem98 -- 自定义项98
    ,o.defitem99 -- 自定义项99
    ,o.defitem100 -- 自定义项100
    ,o.defitem101 -- 自定义项101
    ,o.defitem102 -- 自定义项102
    ,o.defitem103 -- 自定义项103
    ,o.defitem104 -- 自定义项104
    ,o.defitem105 -- 自定义项105
    ,o.defitem106 -- 自定义项106
    ,o.defitem107 -- 自定义项107
    ,o.defitem108 -- 自定义项108
    ,o.defitem109 -- 自定义项109
    ,o.defitem110 -- 自定义项110
    ,o.defitem111 -- 自定义项111
    ,o.defitem112 -- 自定义项112
    ,o.defitem113 -- 自定义项113
    ,o.defitem114 -- 自定义项114
    ,o.defitem115 -- 自定义项115
    ,o.defitem116 -- 自定义项116
    ,o.defitem117 -- 自定义项117
    ,o.defitem118 -- 自定义项118
    ,o.defitem119 -- 自定义项119
    ,o.defitem120 -- 自定义项120
    ,o.defitem121 -- 自定义项121
    ,o.defitem122 -- 自定义项122
    ,o.defitem123 -- 自定义项123
    ,o.defitem124 -- 自定义项124
    ,o.defitem125 -- 自定义项125
    ,o.defitem126 -- 自定义项126
    ,o.defitem127 -- 自定义项127
    ,o.defitem128 -- 自定义项128
    ,o.defitem129 -- 自定义项129
    ,o.defitem130 -- 自定义项130
    ,o.defitem131 -- 自定义项131
    ,o.defitem132 -- 自定义项132
    ,o.defitem133 -- 自定义项133
    ,o.defitem134 -- 自定义项134
    ,o.defitem135 -- 自定义项135
    ,o.defitem136 -- 自定义项136
    ,o.defitem137 -- 自定义项137
    ,o.defitem138 -- 自定义项138
    ,o.defitem139 -- 自定义项139
    ,o.defitem140 -- 自定义项140
    ,o.defitem141 -- 自定义项141
    ,o.defitem142 -- 自定义项142
    ,o.defitem143 -- 自定义项143
    ,o.defitem144 -- 自定义项144
    ,o.defitem145 -- 自定义项145
    ,o.defitem146 -- 自定义项146
    ,o.defitem147 -- 自定义项147
    ,o.defitem148 -- 自定义项148
    ,o.defitem149 -- 自定义项149
    ,o.defitem150 -- 自定义项150
    ,o.defitem151 -- 自定义项151
    ,o.defitem152 -- 自定义项152
    ,o.defitem153 -- 自定义项153
    ,o.defitem154 -- 自定义项154
    ,o.defitem155 -- 自定义项155
    ,o.defitem156 -- 自定义项156
    ,o.defitem157 -- 自定义项157
    ,o.defitem158 -- 自定义项158
    ,o.defitem159 -- 自定义项159
    ,o.defitem160 -- 自定义项160
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
from ${iol_schema}.iers_er_busitem_bk o
    left join ${iol_schema}.iers_er_busitem_op n
        on
            o.pk_busitem = n.pk_busitem
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_er_busitem_cl d
        on
            o.pk_busitem = d.pk_busitem
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_er_busitem;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_er_busitem') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_er_busitem drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_er_busitem add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_er_busitem exchange partition p_${batch_date} with table ${iol_schema}.iers_er_busitem_cl;
alter table ${iol_schema}.iers_er_busitem exchange partition p_20991231 with table ${iol_schema}.iers_er_busitem_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_er_busitem to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_er_busitem_op purge;
drop table ${iol_schema}.iers_er_busitem_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_er_busitem_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_er_busitem',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
