/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_er_busitem
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM iers_er_busitem_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('iers_er_busitem');
  
  if v_var <> 0 then 
    execute immediate 'alter table iers_er_busitem drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table iers_er_busitem add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.iers_er_busitem(
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
            ,0 as qualitydeposit -- 质保金
            ,' ' as pk_resource -- 
            ,' ' as pk_resource_b -- 单据来源子表主键
            ,' ' as remark -- 备注2
            ,' ' as leavedate -- 离开日期
            ,0 as staydates -- 停留日期
            ,' ' as bsarrive -- 到达
            ,0 as isconverd -- 是否转换
            ,' ' as defitem_convert_reason -- 事由
            ,0 as asale_taxrate -- 税率
            ,0 as asale_vat_amount -- 含税金额
            ,' ' as taxitem -- 税收项目
            ,' ' as buytaxno -- 购方税号
            ,' ' as traveldate -- 旅行日期
            ,0 as deductype -- 演绎类型
            ,' ' as enddate -- 结束日期
            ,' ' as arrivedate -- 到达日期
            ,' ' as taxperiod -- 税期
            ,' ' as converexplain -- 自定义
            ,' ' as traffictools -- 交通工具
            ,0 as subsidycosts -- 补贴成本
            ,0 as standardcosts -- 标准成本
            ,' ' as arrive -- 到达
            ,' ' as defitem_asale_reason -- 事由
            ,' ' as buyname -- 买名
            ,' ' as leave -- 离开
            ,0 as asale_tni_amount -- 不含税金额
            ,' ' as notes -- 备注
            ,' ' as asale_explain -- 解释
            ,0 as convert_tax -- 销项税
            ,0 as input_tax -- 进项税
            ,0 as companyrealpay -- 公司实付金额
            ,' ' as pk_trip_orderno -- 指令状态
            ,0 as asale_tax -- 税
            ,0 as isdeemedsale -- 是否视同销售
            ,' ' as startdate -- 开始日期
            ,' ' as defitem81 -- 自定义项81
            ,' ' as defitem82 -- 自定义项82
            ,' ' as defitem83 -- 自定义项83
            ,' ' as defitem84 -- 自定义项84
            ,' ' as defitem85 -- 自定义项85
            ,' ' as defitem86 -- 自定义项86
            ,' ' as defitem87 -- 自定义项87
            ,' ' as defitem88 -- 自定义项88
            ,' ' as defitem89 -- 自定义项89
            ,' ' as defitem90 -- 自定义项90
            ,' ' as defitem91 -- 自定义项91
            ,' ' as defitem92 -- 自定义项92
            ,' ' as defitem93 -- 自定义项93
            ,' ' as defitem94 -- 自定义项94
            ,' ' as defitem95 -- 自定义项95
            ,' ' as defitem96 -- 自定义项96
            ,' ' as defitem97 -- 自定义项97
            ,' ' as defitem98 -- 自定义项98
            ,' ' as defitem99 -- 自定义项99
            ,' ' as defitem100 -- 自定义项100
            ,' ' as defitem101 -- 自定义项101
            ,' ' as defitem102 -- 自定义项102
            ,' ' as defitem103 -- 自定义项103
            ,' ' as defitem104 -- 自定义项104
            ,' ' as defitem105 -- 自定义项105
            ,' ' as defitem106 -- 自定义项106
            ,' ' as defitem107 -- 自定义项107
            ,' ' as defitem108 -- 自定义项108
            ,' ' as defitem109 -- 自定义项109
            ,' ' as defitem110 -- 自定义项110
            ,' ' as defitem111 -- 自定义项111
            ,' ' as defitem112 -- 自定义项112
            ,' ' as defitem113 -- 自定义项113
            ,' ' as defitem114 -- 自定义项114
            ,' ' as defitem115 -- 自定义项115
            ,' ' as defitem116 -- 自定义项116
            ,' ' as defitem117 -- 自定义项117
            ,' ' as defitem118 -- 自定义项118
            ,' ' as defitem119 -- 自定义项119
            ,' ' as defitem120 -- 自定义项120
            ,' ' as defitem121 -- 自定义项121
            ,' ' as defitem122 -- 自定义项122
            ,' ' as defitem123 -- 自定义项123
            ,' ' as defitem124 -- 自定义项124
            ,' ' as defitem125 -- 自定义项125
            ,' ' as defitem126 -- 自定义项126
            ,' ' as defitem127 -- 自定义项127
            ,' ' as defitem128 -- 自定义项128
            ,' ' as defitem129 -- 自定义项129
            ,' ' as defitem130 -- 自定义项130
            ,' ' as defitem131 -- 自定义项131
            ,' ' as defitem132 -- 自定义项132
            ,' ' as defitem133 -- 自定义项133
            ,' ' as defitem134 -- 自定义项134
            ,' ' as defitem135 -- 自定义项135
            ,' ' as defitem136 -- 自定义项136
            ,' ' as defitem137 -- 自定义项137
            ,' ' as defitem138 -- 自定义项138
            ,' ' as defitem139 -- 自定义项139
            ,' ' as defitem140 -- 自定义项140
            ,' ' as defitem141 -- 自定义项141
            ,' ' as defitem142 -- 自定义项142
            ,' ' as defitem143 -- 自定义项143
            ,' ' as defitem144 -- 自定义项144
            ,' ' as defitem145 -- 自定义项145
            ,' ' as defitem146 -- 自定义项146
            ,' ' as defitem147 -- 自定义项147
            ,' ' as defitem148 -- 自定义项148
            ,' ' as defitem149 -- 自定义项149
            ,' ' as defitem150 -- 自定义项150
            ,' ' as defitem151 -- 自定义项151
            ,' ' as defitem152 -- 自定义项152
            ,' ' as defitem153 -- 自定义项153
            ,' ' as defitem154 -- 自定义项154
            ,' ' as defitem155 -- 自定义项155
            ,' ' as defitem156 -- 自定义项156
            ,' ' as defitem157 -- 自定义项157
            ,' ' as defitem158 -- 自定义项158
            ,' ' as defitem159 -- 自定义项159
            ,' ' as defitem160 -- 自定义项160
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from iers_er_busitem_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
