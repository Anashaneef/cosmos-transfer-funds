package main

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

type Transfer struct {
	Sender    sdk.AccAddress
	Recipient sdk.AccAddress
	Amount    sdk.Coins
}

func (t Transfer) Execute(ctx sdk.Context) error {
	// Retrieve the account from the account address
	account := ctx.AccountKeeper().GetAccount(ctx, t.Sender)
	if account == nil {
		return fmt.Errorf("sender account does not exist")
	}

	// Check if the sender has sufficient balance
	if !account.GetCoins().IsAllGTE(t.Amount) {
		return fmt.Errorf("insufficient balance")
	}

	// Transfer the funds from the sender to the recipient
	err := ctx.BankKeeper().SendCoins(ctx, t.Sender, t.Recipient, t.Amount)
	if err != nil {
		return err
	}

	return nil
}

// Declare author information
const (
	AuthorGitHubUsername = "@Anashaneef"
	AuthorWalletAddress  = "0xC44cb74d0ced94120332D697065494131692E979"
)

// Define the entry point of the contract
func main() {
	// Create a new transfer instance
	transfer := Transfer{
		Sender:    sdk.AccAddress("sender_address"),
		Recipient: sdk.AccAddress("recipient_address"),
		Amount:    sdk.NewCoins(sdk.NewInt64Coin("atom", 100)),
	}

	// Execute the transfer
	err := transfer.Execute(sdk.NewContext(nil, nil))
	if err != nil {
		fmt.Println("Error executing transfer:", err.Error())
		return
	}

	fmt.Println("Transfer executed successfully!")
}
